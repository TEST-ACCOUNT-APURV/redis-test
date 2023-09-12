# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke" {
  name                      = "cluster-${var.humanitec_env_type}"
  location                  = var.gcp_zone
  remove_default_node_pool  = true
  initial_node_count        = 1
  datapath_provider         = "ADVANCED_DATAPATH" # Dataplane V2 (NetworkPolicies) is enabled.
  network                   = var.gcp_network
  subnetwork                = var.gcp_sub_network

  addons_config {
    dns_cache_config {
      enabled = true
    }
  }

  release_channel {
    channel = "RAPID"
  }

  ip_allocation_policy {
    # Adding this block enables IP aliasing, making the cluster VPC-native instead of routes-based.
  }

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false

    dynamic "cidr_blocks" {
    for_each = data.humanitec_source_ip_ranges.main.cidr_blocks
    content {
      cidr_block = cidr_blocks.key
    }
    }
    cidr_blocks {
      cidr_block = "${chomp(data.http.icanhazip.response_body)}/32"
    }
  }

  node_config {
    machine_type    = var.gcp_gke_node_size
  }

  confidential_nodes {
    enabled = true
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
        enabled = false
    }
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gcp_gke_master_ipv4_cidr_block
  }

  security_posture_config {
    mode = "BASIC"
    vulnerability_mode = "VULNERABILITY_BASIC"
  }
}

resource "google_container_node_pool" "gke_node_pool" {
  name       = "primary"
  cluster    = google_container_cluster.gke.id
  node_count = 3

  node_config {
    machine_type    = var.gcp_gke_node_size
    service_account = google_service_account.gke_nodes.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}