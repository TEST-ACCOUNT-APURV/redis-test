resource "random_string" "gke_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke" {
  name              = random_string.gke_name.result
  location          = var.region
  enable_autopilot  = true
  network           = google_compute_network.vpc.id
  subnetwork        = google_compute_subnetwork.subnetwork.id

  release_channel {
    channel = var.release_channel
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.gke_nodes.email
      oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    }
  }

  ip_allocation_policy {
    # Adding this block enables IP aliasing, making the cluster VPC-native instead of routes-based.
    cluster_secondary_range_name  = local.pods_range_name
    services_secondary_range_name = local.services_range_name
  }

  node_config {
    machine_type    = var.node_size
    service_account = google_service_account.gke_nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  lifecycle {
    ignore_changes = [
      node_config # otherwise destroy/recreate with Autopilot...
    ]
  }
}