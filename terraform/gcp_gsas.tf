resource "google_service_account" "gke_nodes" {
  account_id    = "gke-${var.humanitec_env_type}-nodes-sa"
  description   = "Account used by the GKE nodes"
}

resource "google_project_iam_member" "gke_nodes" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer"
  ])

  project = var.gcp_project_id
  role    = each.key

  member = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_service_account" "gke_cluster_access" {
  account_id    = "gke-${var.humanitec_env_type}-cluster-access"
  description   = "Account used by Humanitec to access Cloud Logging"
}

resource "google_project_iam_binding" "gke_admin" {
  project   = var.gcp_project_id
  role      = "roles/container.admin"

  members   = [
    "serviceAccount:${google_service_account.gke_cluster_access.email}"
  ]
}

resource "google_service_account_key" "gke_cluster_access_key" {
  service_account_id = google_service_account.gke_cluster_access.name
}

resource "google_service_account" "gke_logging_access" {
  account_id    = "gke-logging-${var.humanitec_env_type}-access"
  description   = "Account used by Humanitec to access Cloud Logging"
}

resource "google_project_iam_binding" "gke_logging_viewer" {
  project   = var.gcp_project_id
  role      = "roles/logging.viewer"

  members   = [
    "serviceAccount:${google_service_account.gke_logging_access.email}"
  ]
}

resource "google_service_account_key" "gke_logging_access_key" {
  service_account_id = google_service_account.gke_logging_access.name
}

resource "google_service_account" "gar_writer_access" {
  account_id    = "gar-${var.humanitec_env_type}-access"
  description   = "Account used by GitHub actions to push container images."
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key.html
resource "google_service_account_key" "gar_writer_access_key" {
  service_account_id = google_service_account.gar_writer_access.name
}