# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service

resource "google_project_service" "apis" {
  for_each = toset([
    "container.googleapis.com",
    "containersecurity.googleapis.com",
    "artifactregistry.googleapis.com",
    "containerscanning.googleapis.com",
    "redis.googleapis.com",
    "containerfilesystem.googleapis.com"
   ])

  service = each.key

  disable_on_destroy = false
}