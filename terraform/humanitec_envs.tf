# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/environment_type

resource "humanitec_environment_type" "env" {
  count       = var.humanitec_env_type == "development" ? 0 : 1
  id          = var.humanitec_env_type
  description = var.humanitec_env_type
}