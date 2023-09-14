# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository

locals {
  gar_containers_name = "containers"
}

resource "google_artifact_registry_repository" "gar_containers" {
  count         = var.humanitec_env_type == "development" ? 1 : 0
  location      = var.gcp_region
  repository_id = local.gar_containers_name
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "gar_containers_reader" {
  location    = var.gcp_region
  repository  = local.gar_containers_name
  role        = "roles/artifactregistry.reader"
  member      = "serviceAccount:${google_service_account.gke_nodes.email}"
  
  depends_on  = [google_artifact_registry_repository.gar_containers]
}

resource "google_artifact_registry_repository_iam_member" "gar_containers_writer" {
  location    = var.gcp_region
  repository  = local.gar_containers_name
  role        = "roles/artifactregistry.writer"
  member      = "serviceAccount:${google_service_account.gar_writer_access.email}"

  depends_on  = [google_artifact_registry_repository.gar_containers]
}