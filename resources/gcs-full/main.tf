locals {
  workload = "${trimprefix(var.workload, "modules.app.externals.")}"
}

resource "random_string" "bucket_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "bucket" {
  name          = random_string.bucket_name.result
  location      = var.region
  force_destroy = true
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam
resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gsa.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gsa" {
  display_name = "${local.workload} service account"
  account_id   = local.workload
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