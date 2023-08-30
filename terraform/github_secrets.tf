# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret

resource "github_actions_secret" "humanitec_org" {
  repository       = var.github_credentials.repository
  secret_name      = "HUMANITEC_ORG"
  plaintext_value  = var.humanitec_credentials.organization
}

resource "github_actions_secret" "humanitec_token" {
  repository       = var.github_credentials.repository
  secret_name      = "HUMANITEC_TOKEN"
  plaintext_value  = var.humanitec_credentials.token
}

resource "github_actions_secret" "container_registry_name" {
  repository       = var.github_credentials.repository
  secret_name      = "CONTAINER_REGISTRY_NAME"
  plaintext_value  = "${google_artifact_registry_repository.gar_containers.location}-docker.pkg.dev/${var.gcp_project_id}/${google_artifact_registry_repository.gar_containers.name}"
}

resource "github_actions_secret" "container_registry_host" {
  repository       = var.github_credentials.repository
  secret_name      = "CONTAINER_REGISTRY_HOST"
  plaintext_value  = "${google_artifact_registry_repository.gar_containers.location}-docker.pkg.dev"
}

resource "github_actions_secret" "container_registry_writer_key" {
  repository       = var.github_credentials.repository
  secret_name      = "CONTAINER_REGISTRY_WRITER_KEY"
  plaintext_value  = base64decode(google_service_account_key.gar_writer_access_key.private_key)
}