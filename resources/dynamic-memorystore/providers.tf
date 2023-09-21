terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }

    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "google" {
  project = var.credentials.project_id
}