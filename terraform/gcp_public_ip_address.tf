# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "public_ingress" {
  name          = "public-ingress-${var.humanitec_env_type}"
  address_type  = "EXTERNAL"
}