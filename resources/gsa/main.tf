resource "random_string" "name_suffix" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gsa" {
  display_name = "${var.name_prefix} service account"
  account_id   = "${var.name_prefix}-${random_string.name_suffix.result}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "wi" {
  count               = var.workload_identity == null ? 0 : 1
  service_account_id  = google_service_account.gsa.name
  role                = "roles/iam.workloadIdentityUser"
  member              = "serviceAccount:${var.workload_identity.gke_project_id}.svc.id.goog[${var.workload_identity.namespace}/${var.workload_identity.ksa}]"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_project_iam_member" "roles" {
  for_each = var.roles

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gsa.email}"
}