```bash
cd resources/cloudsql-new

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
    -var location=${LOCATION} \
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
cat <<EOF > cloudsql-new.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: cloudsql-new
entity:
  name: cloudsql-new
  type: redis
  driver_type: humanitec/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/cloudsql-new
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: ${PROJECT_ID}
        location: ${LOCATION}
    secrets:
      variables:
        credentials: $(cat ${SA_NAME}.json | jq -r tostring)
  criteria:
    - env_id: ${ENVIRONMENT}
EOF
```

```bash
humctl create \
    -f cloudsql-new.yaml
```