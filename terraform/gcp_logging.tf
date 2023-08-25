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