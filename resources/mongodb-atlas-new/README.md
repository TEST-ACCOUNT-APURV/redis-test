```bash
cd resources/mongodb-atlas-new

ATLAS_PUBLIC_KEY=FIXME
ATLAS_PRIVATE_KEY=FIXME
ATLAS_PROJECT_ID=FIXME
CLUSTER_REGION=FIXME
```

## Run Terraform locally

```bash
terraform init -upgrade

terraform validate

terraform plan \
	-var project_id=${ATLAS_PROJECT_ID} \
	-var public_key=${ATLAS_PUBLIC_KEY} \
	-var private_key=${ATLAS_PRIVATE_KEY} \
  -var region=${CLUSTER_REGION} \
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
cat <<EOF > mongodb-atlas-new.yaml
apiVersion: entity.humanitec.io/v1b1
kind: Definition
metadata:
  id: mongodb-atlas-new
entity:
  name: mongodb-atlas-new
  type: mongo
  driver_type: humanitec/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/mongodb-atlas-new
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git
      variables:
        project_id: ${PROJECT_ID}
        region: ${CLUSTER_REGION}
    secrets:
      variables:
        public_key: ${ATLAS_PUBLIC_KEY}
        private_key: ${ATLAS_PRIVATE_KEY}
  criteria:
    - env_id: ${HUMANITEC_ENVIRONMENT}
EOF
```

```bash
humctl create \
    -f mongodb-atlas-new.yaml
```
