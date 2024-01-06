```bash
cd resources/gcs-full

PROJECT_ID=FIXME
REGION=FIXME
```

## Create the GSA to provision the Terraform resources

```bash
SA_NAME=humanitec-terraform
SA_ID=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
gcloud iam service-accounts create ${SA_NAME} \
    --display-name=${SA_NAME}
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

NAMESPACE=namespace-name
RES_ID=modules.workload-id.externals.resource-id
KSA=ksa-name

terraform plan \
    -var credentials="$(cat ${SA_NAME}.json | jq -r tostring)" \
    -var project_id=${PROJECT_ID} \
    -var namespace=${NAMESPACE} \
    -var res_id=${RES_ID} \
    -var ksa=${KSA} \
    -out tfplan

terraform apply \
    tfplan
```

## Create the associated resource definition in Humanitec

```bash
HUMANITEC_ORG=FIXME
HUMANITEC_ENVIRONMENT=FIXME
```

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
        project_id: ${PROJECT_ID}
        gke_project_id: \${resources.k8s-cluster.outputs.project_id}
        namespace: \${resources.k8s-namespace.outputs.namespace}
        ksa: \${resources.k8s-service-account.outputs.name}
        res_id: \${context.res.id}
    secrets:
      variables:
        credentials: '$(cat ${SA_NAME}.json | jq -r tostring)'
  criteria:
    - {}
EOF
```

```bash
humctl create \
    -f gsa.yaml
```