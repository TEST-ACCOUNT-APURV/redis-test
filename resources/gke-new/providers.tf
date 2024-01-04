terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    helm = {
      source = "hashicorp/helm"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "google" {
  project     = var.project_id
  credentials = var.credentials
}

provider "helm" {
  kubernetes {
    host                    = "https://${google_container_cluster.gke.endpoint}"
    token                   = data.google_client_config.default.access_token
    cluster_ca_certificate  = base64decode(
      google_container_cluster.gke.master_auth.0.cluster_ca_certificate
    )
  }
}

data "google_client_config" "default" {}