# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance
resource "google_redis_instance" "memorystore" {
  name              = "redis-cache-${var.humanitec_env_type}"
  memory_size_gb    = 1
  redis_version     = "REDIS_6_X"
  region            = var.gcp_region
  auth_enabled      = true
}