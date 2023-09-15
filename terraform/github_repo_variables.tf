# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable

resource "github_actions_variable" "repo_cloud_provider" {
  count             = var.humanitec_env_type == "development" && var.github_create_repo_secrets ? 1 : 0
  repository        = var.github_credentials.repository
  variable_name     = "CLOUD_PROVIDER"
  value             = "google-cloud"
}