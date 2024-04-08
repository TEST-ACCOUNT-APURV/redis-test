resource "random_string" "memorystore_instance_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance
resource "google_redis_instance" "memorystore" {
  name                = "redis-${random_string.memorystore_instance_name.result}"
  memory_size_gb      = 1
  redis_version       = "REDIS_7_0"
  region              = var.region
  auth_enabled        = false
  authorized_network  = data.google_compute_network.vpc.id
}

data "google_compute_network" "vpc" {
  name = var.network
}
