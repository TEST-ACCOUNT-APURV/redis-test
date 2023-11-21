# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition

resource "humanitec_resource_definition" "gcp_dynamic_memorystore_redis" {
  count       = var.enable_redis ? 1 : 0
  id          = "dynamic-memorystore"
  name        = "dynamic-memorystore"
  type        = "redis"
  driver_type = "humanitec/terraform"

  driver_inputs = {
    values_string = jsonencode({
      append_logs_to_error = true
      source = {
        path = "resources/memorystore-new"
        url = "https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture.git"
        rev = "refs/heads/main"
      }
    })

    secrets_string = jsonencode({
      credentials = "FIXME"
    })
  }

  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}

#resource "humanitec_resource_definition_criteria" "gcp_dynamic_memorystore_redis" {
#  resource_definition_id = humanitec_resource_definition.gcp_dynamic_memorystore_redis.id
#}
