locals {
  workload_name = "${element(split(var.res_id, "."), length(split(var.res_id, "."))-1)}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gsa" {
  display_name = "${local.workload_name} service account"
  account_id   = local.workload_name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_project_iam_member" "role" {
  for_each = var.roles

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gsa.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "wi" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.ksa}]"
}