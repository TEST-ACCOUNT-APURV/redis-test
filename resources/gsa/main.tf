locals {
  # FIXME - needs to be tested with shared too.
  # Only tested in this format so far: "modules.workload-id.externals.resource-id".
  gsa_name = "${split(".", var.res_id)[1]}-gsa"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gsa" {
  display_name = "${local.gsa_name} service account"
  account_id   = local.gsa_name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "wi" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.gke_project_id}.svc.id.goog[${var.namespace}/${var.ksa}]"
}