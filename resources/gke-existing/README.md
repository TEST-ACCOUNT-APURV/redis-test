```bash
cat <<EOF > aks-cluster-existing.yaml
apiVersion: core.api.humanitec.io/v1
kind: Definition
metadata:
  id: aks-cluster-existing
object:
  name: aks-cluster-existing
  type: k8s-cluster
  driver_type: ${HUMANITEC_ORG}/terraform
  driver_inputs:
    values:
      append_logs_to_error: true
      source:
        path: resources/terraform/azure-aks-existing
        rev: refs/heads/main
        url: https://github.com/Humanitec-DemoOrg/azure-reference-architecture.git
      variables:
        aks_cluster_name: ${AZURE_AKS_CLUSTER_NAME}
        resource_group_name: ${AZURE_RESOURCE_GROUP}
        ingress_nginx_public_ip_address: ${AZURE_AKS_CLUSTER_NAME}-ingress-nginx
    secrets:
      variables:
        credentials:
          azure_subscription_id: ${AZURE_SUBSCRIPTION_ID}
          azure_subscription_tenant_id: ${AZURE_SUBSCRIPTION_TENANT_ID}
          service_principal_id: ${TERRAFORM_CONTRIBUTOR_SP_ID}
          service_principal_password: ${TERRAFORM_CONTRIBUTOR_SP_PASSWORD}
  criteria:
    - env_id: ${AZURE_ENVIRONMENT}
      app_id: triton
EOF
humctl create \
    -f aks-cluster-existing.yaml
```