```bash
cd resources/gke-existing
```

## Create the GSA to provision the Terraform resources

```bash
SA_NAME=humanitec-to-${CLUSTER_NAME}
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

## Create the associated resource definition in Humanitec

```bash
ENVIRONMENT=FIXME

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
    - env_id: ${ENVIRONMENT}
EOF
```

Here in that `gke-cluster-existing.yaml` file, you need to manually format the YAML indentation in the `driver_inputs.secrets.variables.credentials` section.

```bash
humctl create \
    -f gke-cluster-existing.yaml
```