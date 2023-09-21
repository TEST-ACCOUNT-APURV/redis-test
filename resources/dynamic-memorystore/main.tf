resource "random_string" "memorystore_instance_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance
resource "google_redis_instance" "memorystore_instance" {
  name              = random_string.memorystore_instance_name.result
  memory_size_gb    = 1
  redis_version     = "REDIS_6_X"
  region            = var.gcp_region
  auth_enabled      = true
}