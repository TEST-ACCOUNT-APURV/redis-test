terraform {
  required_providers {
    humanitec = {
      source = "humanitec/humanitec"
      version = ">= 0.11.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.78.0"
    }
  }
}

provider "humanitec" {
  org_id = var.humanitec_credentials.organization
  token  = var.humanitec_credentials.token
}

provider "google" {
  project = var.gcp_project_id
}

data "humanitec_source_ip_ranges" "main" {}