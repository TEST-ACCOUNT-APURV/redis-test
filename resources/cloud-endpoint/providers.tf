terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }

    template = {
      source  = "hashicorp/template"
    }
  }
}

provider "google" {
  project     = var.project_id
  credentials = var.credentials
}