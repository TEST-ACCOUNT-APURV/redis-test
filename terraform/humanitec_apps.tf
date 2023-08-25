# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/application

resource "humanitec_application" "app" {
  count = var.humanitec_env_type == "development" ? 1 : 0
  id    = var.humanitec_app_name
  name  = var.humanitec_app_name
}