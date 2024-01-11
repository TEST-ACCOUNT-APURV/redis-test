This GCS setup (i.e. `gcs` resource definition) needs other resource definitions:
- `workload`
- `k8s-service-account`
- `gcp-service-account`
- `config`

Remaining tasks:
- Test with shared GCS
- Test with Operator
- Change the GSA name, needs to be `workload-k8s-namespace` format for unicity
- Optimize the resource graph (2 `configs` instead of 1 and 3 `k8s-service-accounts` instead of 1)
- Remove the `gsa` in Score, Dev shouldn't provide this

Targeted resource graph:
```mermaid
graph LR
  workload -- references --> k8s-service-account
  k8s-service-account -- references --> google-service-account
  gcs -- references --> google-service-account
  workload -- score --> gcs
```

Current resource graph (FIXME):

![](resource-graph.png)

```bash
cd resources/gcs-full
```

## Create the Humanitec App

```bash
APP=FIXME
```

```bash
humctl create app ${APP} \
    --name ${APP}
```

## Create the GSA to provision the Terraform resources

```bash
PROJECT_ID=FIXME
SA_NAME=humanitec-terraform
SA_ID=${SA_NAME}@${GSA_PROJECT_ID}.iam.gserviceaccount.com

gcloud iam service-accounts create ${SA_NAME} \
    --display-name=${SA_NAME} \
    --project 
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_ID}" \
    --role "roles/editor"
gcloud iam service-accounts keys create ${SA_NAME}.json \
    --iam-account ${SA_ID}
```

## Run Terraform locally

```bash
terraform init -upgrade

terraform validate

GCS_REGION=FIXME
GCS_PROJECT_ID=FIXME
NAMESPACE=namespace
WORKLOAD=workload
KSA=ksa

terraform plan \
    -var credentials="$(cat ${SA_NAME}.json | jq -r tostring)" \
    -var project_id=${GCS_PROJECT_ID} \
    -var region=${GCS_REGION} \
    -var namespace=${NAMESPACE} \
    -var workload=${WORKLOAD} \
    -var ksa=${KSA} \
    -out tfplan

terraform apply \
    tfplan
```

## Create the associated resource definitions in Humanitec

```bash
HUMANITEC_ORG=FIXME
HUMANITEC_TOKEN=FIXME
```

### Create the App's `config` resource definition

```bash
PROJECT_ID=FIXME
REGION=FIXME

ENVIRONMENT=development
```

```bash
cat <<EOF > ${APP}-${ENVIRONMENT}-config.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: ${APP}-${ENVIRONMENT}-config
entity:
  name: ${APP}-${ENVIRONMENT}-config
  type: config
  driver_type: humanitec/template
  driver_inputs:
    values:
      templates:
        outputs: |
          project_id: ${PROJECT_ID}
          region: ${REGION}
    secrets:
      templates:
        outputs: |
          credentials: '$(cat ${SA_NAME}.json | jq -r tostring)'
  criteria:
    - app_id: ${APP}
      env_id: ${ENVIRONMENT}
EOF

humctl create \
    -f ${APP}-${ENVIRONMENT}-config.yaml
```

### Create the `gcs` resource definition

Define the `gcs` resource definition:
```bash
cat <<EOF > gcs-full.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: gcs-full
entity:
  name: gcs-full
  type: gcs
  driver_type: humanitec/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/gcs-full
        rev: refs/heads/rework
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: \${resources.config.default#config.outputs.project_id}
        region: \${resources.config.default#config.outputs.region}
        namespace: \${resources.k8s-namespace.default#k8s-namespace.outputs.namespace}
        gsa_email: \${resources.gcp-service-account.outputs.email}
    secrets:
      variables:
        credentials: \${resources.config.default#config.outputs.credentials}
  criteria:
    - {}
EOF

humctl apply \
    -f gcs-full.yaml
```

### Create the `gcp-service-account` resource definition

```bash
cat <<EOF > gsa.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: gsa
entity:
  name: gsa
  type: gcp-service-account
  driver_type: humanitec/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/gsa
        rev: refs/heads/rework
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: \${resources.config.outputs.project_id}
        name_prefix: {{ index (regexSplit "\\\\." "\$\${context.res.id}" -1) 1 }}
        workload_identity:
          gke_project_id: \${resources.k8s-cluster.outputs.project_id}
          namespace: \${resources.k8s-namespace.outputs.namespace}
          ksa: {{ index (regexSplit "\\\\." "\$\${context.res.id}" -1) 1 }}
    secrets:
      variables:
        credentials: \${resources.config.outputs.credentials}
  criteria:
    - {}
EOF

humctl create \
    -f gsa.yaml
```

### Create the `workload` resource definition

```bash
cat <<EOF > custom-workload.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: custom-workload
entity:
  name: custom-workload
  type: workload
  driver_type: humanitec/template
  driver_inputs:
    values:
      templates:
        outputs: |
          update:
            - op: add
              path: /spec/serviceAccountName
              value: \${resources.k8s-service-account.outputs.name}
  criteria:
    - {}
EOF

humctl create \
    -f custom-workload.yaml
```
_Note: we are making a decision here to have a Kubernetes `ServiceAccount` per Workload, for any Workloads. See next section to see how this `ServiceAccount` is created._

### Create the `k8s-service-account` resource definition

Now, for any `k8s-service-account` explicitly defined with `class: workload-identity`, we will define this `ServiceAccount` with the Workload Identity annotation:
```bash
cat <<EOF > custom-service-account.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: custom-service-account
entity:
  name: custom-service-account
  type: k8s-service-account
  driver_type: humanitec/template
  driver_inputs:
    values:
      templates:
        init: |
          name: {{ index (regexSplit "\\\\." "\$\${context.res.id}" -1) 1 }}
        manifests: |-
          service-account.yaml:
            location: namespace
            data:
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                annotations:
                  iam.gke.io/gcp-service-account: \${resources.gcp-service-account.outputs.email}
                name: {{ .init.name }}
        outputs: |
          name: {{ .init.name }}
  criteria:
    - {}
EOF

humctl create \
    -f custom-service-account.yaml
```

## Deploy the sample app using this GCS setup

```bash
score-humanitec delta \
    --app ${APP} \
    --env ${ENVIRONMENT} \
    --org ${HUMANITEC_ORG} \
    --token ${HUMANITEC_TOKEN} \
    --deploy \
    --retry \
    -f score.yaml
```
