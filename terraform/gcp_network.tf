# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router" {
  name    = "cluster-${var.humanitec_env_type}"
  network = var.gcp_network
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
    name                                = var.gcp_sub_network
    source_ip_ranges_to_nat             = ["ALL_IP_RANGES"]
  }
}