This GSA setup (i.e. `gcp-service-account` resource definition) needs other resource definitions:
- `config`

```bash
cd resources/gsa
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

RES_ID=modules.workload-id.externals.resource-id

terraform plan \
    -var credentials="$(cat ${SA_NAME}.json | jq -r tostring)" \
    -var project_id=${PROJECT_ID} \
    -var res_id=${RES_ID} \
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
```

```bash
cat <<EOF > ${APP}-app-config.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: ${APP}-app-config
entity:
  name: ${APP}-app-config
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
      class: default
EOF

humctl create \
    -f ${APP}-app-config.yaml
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
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: \${resources.config.outputs.project_id}
        res_id: \${context.res.id}
    secrets:
      variables:
        credentials: \${resources.config.outputs.credentials}
  criteria:
    - {}
EOF

humctl create \
    -f gsa.yaml
```

For an example with Workload Identity, see [`gcs`](../gcs-full/).