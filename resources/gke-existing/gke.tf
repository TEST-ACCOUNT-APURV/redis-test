# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster
data "google_container_cluster" "gke" {
  name      = var.gke_name
  location  = var.gke_location
}