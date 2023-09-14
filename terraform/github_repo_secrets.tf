# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret

/*resource "github_actions_secret" "repo_humanitec_org" {
  count             = var.humanitec_env_type == "development" && var.github_create_org_secrets == false ? 1 : 0
  repository        = var.github_credentials.repository
  secret_name       = "HUMANITEC_ORG"
  plaintext_value   = var.humanitec_credentials.organization
}

resource "github_actions_secret" "repo_humanitec_token" {
  count             = var.humanitec_env_type == "development" && var.github_create_org_secrets == false ? 1 : 0
  repository        = var.github_credentials.repository
  secret_name       = "HUMANITEC_TOKEN"
  plaintext_value   = var.humanitec_credentials.token
}

resource "github_actions_secret" "repo_container_registry_name" {
  count             = var.humanitec_env_type == "development" && var.github_create_org_secrets == false ? 1 : 0
  repository        = var.github_credentials.repository
  secret_name       = "GCP_GAR_NAME"
  plaintext_value   = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${local.gar_containers_name}"
}

resource "github_actions_secret" "repo_container_registry_host" {
  count             = var.humanitec_env_type == "development" && var.github_create_org_secrets == false ? 1 : 0
  repository        = var.github_credentials.repository
  secret_name       = "GCP_GAR_HOST"
  plaintext_value   = "${var.gcp_region}-docker.pkg.dev"
}

resource "github_actions_secret" "repo_container_registry_writer_key" {
  count             = var.humanitec_env_type == "development" && var.github_create_org_secrets == false ? 1 : 0
  repository        = var.github_credentials.repository
  secret_name       = "GCP_GAR_WRITER_KEY"
  plaintext_value   = base64decode(google_service_account_key.gar_writer_access_key.private_key)
}*/