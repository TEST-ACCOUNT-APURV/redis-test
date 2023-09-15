# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition

resource "humanitec_resource_definition" "gcp_logging" {
  id          = "gcp-logging-${var.humanitec_env_type}"
  name        = "gcp-logging-${var.humanitec_env_type}"
  type        = "logging"
  driver_type = "humanitec/logging-gcp"

  driver_inputs = {
    values_string = jsonencode({
      cluster_name = "$${resources.k8s-cluster#k8s-cluster.outputs.name}"
      cluster_zone = "$${resources.k8s-cluster#k8s-cluster.outputs.zone}"
      project_id   = "$${resources.k8s-cluster#k8s-cluster.outputs.project_id}"
    })
    secrets_string = jsonencode({
      credentials = jsondecode(base64decode(google_service_account_key.gke_logging_access_key.private_key))
    })
  }

  lifecycle {
    ignore_changes = [
      criteria
    ]
  }

  depends_on = [humanitec_resource_definition.gke]
}

resource "humanitec_resource_definition_criteria" "gcp_logging" {
  resource_definition_id = humanitec_resource_definition.gcp_logging.id
  env_type               = var.humanitec_env_type
}