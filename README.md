# google-cloud-reference-architecture

For each Environment, just change this value:
```bash
ENVIRONMENT_TYPE=development
```

```bash
cd terraform/environment

gcloud auth application-default login

terraform workspace new ${ENVIRONMENT_TYPE}
terraform workspace select ${ENVIRONMENT_TYPE}

terraform init

terraform plan \
    -var humanitec_credentials="{\"organization\"=\"${HUMANITEC_ORG}\", \"token\"=\"${HUMANITEC_TOKEN}\"}" \
    -var humanitec_app_name=${HUMANITEC_APP} \
    -var gcp_project_id=${PROJECT_ID} \
    -var humanitec_env_type=${ENVIRONMENT_TYPE} \
    -out tfplan

terraform apply \
    tfplan
```