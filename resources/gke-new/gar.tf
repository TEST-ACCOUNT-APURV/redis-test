# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository_iam

resource "google_artifact_registry_repository_iam_member" "gar_containers_reader" {
  location    = var.region
  repository  = var.existing_gar_repo_name
  role        = "roles/artifactregistry.reader"
  member      = "serviceAccount:${google_service_account.gke_nodes.email}"
}