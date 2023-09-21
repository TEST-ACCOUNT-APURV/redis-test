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
        path: resources/terraform/gke-existing
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
        credentials: ${GCP_CREDENTIALS}
  criteria:
    - env_id: ${GCP_ENVIRONMENT}
      app_id: triton
EOF
humctl create \
    -f gke-cluster-existing.yaml
```