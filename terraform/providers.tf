terraform {
  required_providers {
    humanitec = {
      source = "humanitec/humanitec"
    }
    google = {
      source  = "hashicorp/google"
    }
    github = {
      source = "integrations/github"
    }
    helm = {
      source = "hashicorp/helm"
    }
    http = {
      source = "hashicorp/http"
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

provider "github" {
  owner = var.github_credentials.organization
  token = var.github_credentials.token
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