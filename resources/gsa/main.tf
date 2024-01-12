locals {
  # Only tested in this format so far: "modules.workload-id.externals.resource-id".
  gsa_name = "${split(".", var.res_id)[1]}-gsa"
}

resource "random_string" "name_suffix" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gsa" {
  display_name = "${local.gsa_name} service account"
  account_id   = "${local.gsa_name}-${random_string.name_suffix.result}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "wi" {
  count               = var.workload_identity == null ? 0 : 1
  service_account_id  = google_service_account.gsa.name
  role                = "roles/iam.workloadIdentityUser"
  member              = "serviceAccount:${var.workload_identity.gke_project_id}.svc.id.goog[${var.workload_identity.namespace}/${local.gsa_name}]"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam
resource "google_storage_bucket_iam_member" "gcs_iam_members" {
  for_each = var.iam_member_resource_names

  role    = "roles/storage.admin"
  bucket  = each.key
  member  = "serviceAccount:${google_service_account.gsa.email}"
}