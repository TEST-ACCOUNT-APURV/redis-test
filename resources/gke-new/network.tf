locals {
  services_range_name = "services"
  pods_range_name = "pods"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc" {
  name                    = random_string.gke_name.result
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "subnetwork" {
  network                   = google_compute_network.vpc.id
  name                      = random_string.gke_name.result
  ip_cidr_range             = "10.2.0.0/20"
  region                    = var.region

  secondary_ip_range {
    range_name    = local.services_range_name
    ip_cidr_range = "10.3.0.0/20"
  }
  secondary_ip_range {
    range_name    = local.pods_range_name
    ip_cidr_range = "10.4.0.0/20"
  }
}