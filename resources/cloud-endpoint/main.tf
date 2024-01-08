locals {
  dns = "${var.dns_prefix}.endpoints.${var.project_id}.cloud.goog"
}

data "template_file" "openapi_spec" {
  template = "${file("openapi_spec.yml")}"
  vars = {
    DNS = local.dns,
    IP_ADDRESS = var.ip_address
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/endpoints_service
resource "google_endpoints_service" "api-service" {
  service_name = local.dns
  project = var.project_id
  openapi_config = data.template_file.openapi_spec.rendered
}