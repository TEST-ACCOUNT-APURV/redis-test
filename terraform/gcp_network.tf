# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc" {
  name                    = var.humanitec_env_type
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "subnetwork" {
  network                   = google_compute_network.vpc.id
  name                      = var.humanitec_env_type
  ip_cidr_range             = "10.2.0.0/20"
  region                    = var.gcp_region

  secondary_ip_range {
    range_name    = "servicesrange"
    ip_cidr_range = "10.3.0.0/20"
  }
  secondary_ip_range {
    range_name    = "clusterrange"
    ip_cidr_range = "10.4.0.0/20"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router" {
  name    = "cluster-${var.humanitec_env_type}"
  network = google_compute_network.vpc.name
  region  = var.gcp_region
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "router_nat" {
  name                                  = "cluster-${var.humanitec_env_type}"
  router                                = google_compute_router.router.name
  nat_ip_allocate_option                = "AUTO_ONLY"
  region                                = var.gcp_region
  source_subnetwork_ip_ranges_to_nat    = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                                = google_compute_subnetwork.subnetwork.name
    source_ip_ranges_to_nat             = ["ALL_IP_RANGES"]
  }
}