# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "public_ingress" {
  name          = "public-ingress-${var.humanitec_env_type}"
  address_type  = "EXTERNAL"
  region        = var.gcp_region
}