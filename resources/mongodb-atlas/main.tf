resource "random_string" "mongodbatlas_cluster_name" {
  length  = 10
  special = false
  lower   = true
  upper   = true
}

# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cluster
resource "mongodbatlas_cluster" "cluster" {
  project_id                  = var.project_id
  name                        = random_string.mongodbatlas_cluster_name.result
  mongo_db_major_version      = var.cluster_version
  provider_name               = var.provider_name
  backing_provider_name       = var.backing_provider_name 
  provider_region_name        = var.region
  provider_instance_size_name = var.provider_instance_size_name
}