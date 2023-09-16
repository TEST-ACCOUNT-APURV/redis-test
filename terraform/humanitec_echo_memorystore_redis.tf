# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition

resource "humanitec_resource_definition" "gcp_echo_memorystore_redis" {
  count       = var.enable_redis ? 1 : 0
  id          = "echo-memorystore-${var.humanitec_env_type}"
  name        = "echo-memorystore-${var.humanitec_env_type}"
  type        = "redis"
  driver_type = "humanitec/echo"

  driver_inputs = {
    values_string = jsonencode({
      host = google_redis_instance.memorystore.host
      port = google_redis_instance.memorystore.port
    })
    secrets_string = jsonencode({
      password = google_redis_instance.memorystore.auth_string
    })
  }

  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}

#resource "humanitec_resource_definition_criteria" "gcp_echo_memorystore_redis" {
#  resource_definition_id = humanitec_resource_definition.gcp_echo_memorystore_redis.id
#}