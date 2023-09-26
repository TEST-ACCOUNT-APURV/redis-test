# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "public_ingress" {
  name          = random_string.gke_name.result
  address_type  = "EXTERNAL"
  region        = var.region
}