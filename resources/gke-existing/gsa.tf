# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_service_account" "gke_cluster_access" {
  account_id    = "humanitec-to-${var.gke_name}"
  description   = "Account used by Humanitec to access the GKE cluster"
}

resource "google_project_iam_member" "gke_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke_cluster_access.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key#private_key
resource "google_service_account_key" "gke_cluster_access_key" {
  service_account_id = google_service_account.gke_cluster_access.name
}