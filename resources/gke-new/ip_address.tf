# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "public_ingress" {
  name          = local.gke_name
  address_type  = "EXTERNAL"
  region        = var.region
}