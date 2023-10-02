```bash
cd resources/memorystore-new

PROJECT_ID=FIXME
REGION=FIXME
NETWORK=FIXME
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

terraform plan \
    -var credentials="$(cat ${SA_NAME}.json | jq -r tostring)" \
    -var project_id=${PROJECT_ID} \
    -var region=${REGION} \
    -var network=${NETWORK} \
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
cat <<EOF > memorystore-new.yaml
apiVersion: core.api.humanitec.io/v1
kind: Definition
metadata:
  id: memorystore-new
object:
  name: memorystore-new
  type: k8s-cluster
  driver_type: ${HUMANITEC_ORG}/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/memorystore-new
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: ${PROJECT_ID}
        region: ${REGION}
        network: ${NETWORK}
    secrets:
      variables:
        credentials: $(cat ${SA_NAME}.json | jq -r tostring)
  criteria:
    - env_id: ${ENVIRONMENT}
EOF
```

```bash
humctl create \
    -f memorystore-new.yaml
```