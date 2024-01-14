resource "random_string" "mongodbatlas_cluster_name" {
  length  = 10
  special = false
  lower   = true
  upper   = true
}

resource "random_string" "mongodbatlas_cluster_username" {
  length  = 10
  special = false
  lower   = true
  upper   = true
}

resource "random_string" "mongodbatlas_cluster_password" {
  length  = 20
  special = true
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

# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user
resource "mongodbatlas_database_user" "user" {
  username           = random_string.mongodbatlas_cluster_username.result
  password           = random_string.mongodbatlas_cluster_password.result
  project_id         = var.project_id
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}

# https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list
resource "mongodbatlas_project_ip_access_list" "ips" {
  for_each = var.ip_access_list
  
  project_id = var.project_id
  ip_address = each.key
}