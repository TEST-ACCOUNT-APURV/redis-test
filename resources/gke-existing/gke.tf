# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster
data "google_container_cluster" "gke" {
  name      = var.gke_cluster_name
  location  = var.gke_cluster_location
}