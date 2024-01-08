```bash
cd resources/gcs-new

PROJECT_ID=FIXME
IP_ADDRESS=FIXME
DNS_PREFIX=test-test
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
    -var ip_address=${IP_ADDRESS} \
    -var dns_prefix=${DNS_PREFIX} \
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
cat <<EOF > cloud-endpoint.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: cloud-endpoint
entity:
  name: cloud-endpoint
  type: dns
  driver_type: humanitec/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/cloud-endpoint
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: ${PROJECT_ID}
        ip_address: ${IP_ADDRESS}
        dns_prefix: ${DNS_PREFIX}
    secrets:
      variables:
        credentials: '$(cat ${SA_NAME}.json | jq -r tostring)'
  criteria:
    - env_id: ${ENVIRONMENT}
EOF

humctl create \
    -f cloud-endpoint.yaml
```