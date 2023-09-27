```bash
cd resources/gke-new
```

## Create the GSA to provision the Terraform resources

```bash
SA_NAME=humanitec-to-${CLUSTER_NAME}
SA_ID=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
gcloud iam service-accounts create ${SA_NAME} \
    --display-name=${SA_NAME}
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_ID}" \
    --role "roles/owner"
gcloud iam service-accounts keys create ${SA_NAME}.json \
    --iam-account ${SA_ID}
```

## Run Terraform locally

```bash
terraform init -upgrade

terraform validate

terraform plan \
    -var credentials="$(cat ${SA_NAME}.json | jq tostring)" \
    -var project_id=${PROJECT_ID} \
    -var region=${REGION} \
    -var existing_gar_repo_name=${GAR_NAME} \
    -out tfplan

terraform apply \
    tfplan
```

## Create the associated resource definition in Humanitec

```bash
ENVIRONMENT=FIXME

cat <<EOF > gke-cluster-new.yaml
apiVersion: core.api.humanitec.io/v1
kind: Definition
metadata:
  id: gke-cluster-new
object:
  name: gke-cluster-new
  type: k8s-cluster
  driver_type: ${HUMANITEC_ORG}/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/gke-new
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: ${PROJECT_ID}
        region: ${REGION}
        existing_gar_repo_name: ${GAR_NAME}
    secrets:
      variables:
        credentials: $(cat ${SA_NAME}.json | jq -r tostring)
    - env_id: ${ENVIRONMENT}
EOF
```

```bash
humctl create \
    -f gke-cluster-existing.yaml
```