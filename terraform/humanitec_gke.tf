# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition

resource "humanitec_resource_definition" "gke" {
  id          = "gke-${var.humanitec_env_type}"
  name        = "gke-${var.humanitec_env_type}"
  type        = "k8s-cluster"
  driver_type = "humanitec/k8s-cluster-gke"

  driver_inputs = {
    values = {
      "loadbalancer" = data.kubernetes_service.ingress_nginx_controller.status.0.load_balancer.0.ingress.0.ip
      "name"         = google_container_cluster.gke.name
      "project_id"   = var.gcp_project_id
      "zone"         = var.gcp_zone
    }
    secrets = {
      "credentials" = base64decode(google_service_account_key.gke_cluster_access_key.private_key)
    }
  }

  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}

resource "humanitec_resource_definition_criteria" "gke" {
  resource_definition_id = humanitec_resource_definition.gke.id
  env_type               = var.humanitec_env_type
}