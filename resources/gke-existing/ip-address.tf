# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "google_compute_address" "public_ip" {
  name    = var.ip_address_name
  region  = var.ip_address_region
}
