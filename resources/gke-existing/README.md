```bash
cd resources/gke-existing

PROJECT_ID=FIXME
GKE_NAME=FIXME
GKE_LOCATION=FIXME
IP_ADDRESS_NAME=FIXME
IP_ADDRESS_REGION=FIXME
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
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_ID}" \
    --role "roles/resourcemanager.projectIamAdmin"
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
    -var gke_name=${GKE_NAME} \
    -var gke_location=${GKE_LOCATION} \
    -var ip_address_name=${IP_ADDRESS_NAME} \
    -var ip_address_region=${IP_ADDRESS_REGION} \
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
cat <<EOF > gke-cluster-existing.yaml
apiVersion: core.api.humanitec.io/v1
kind: Definition
metadata:
  id: gke-cluster-existing
object:
  name: gke-cluster-existing
  type: k8s-cluster
  driver_type: ${HUMANITEC_ORG}/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/gke-existing
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: ${PROJECT_ID}
        gke_name: ${GKE_NAME}
        gke_location: ${GKE_LOCATION}
        ip_address_name: ${IP_ADDRESS_NAME}
        ip_address_region: ${IP_ADDRESS_REGION}
    secrets:
      variables:
        credentials: $(cat ${SA_NAME}.json | jq -r tostring)
  criteria:
    - env_id: ${HUMANITEC_ENVIRONMENT}
EOF
```

```bash
humctl create \
    -f gke-cluster-existing.yaml
```