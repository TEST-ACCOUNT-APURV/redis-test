variable "humanitec_credentials" {
  description = "The credentials for connecting to Humanitec."
  type = object({
    organization    = string
    token           = string
  })
  sensitive = true
}

variable "humanitec_app_name" {
  description   = "Name of the Humanitec App to create."
  type          = string
}

variable "humanitec_env_type" {
  description   = "Type and Id of the Humanitec Env to create."
  type          = string
  default       = "development"
}

variable "gcp_project_id" {
  description   = "Id of the Google Cloud Project where the services are provisioned."
  type          = string
}

variable "gcp_region" {
  description   = "Region where the Google Cloud services are provisioned."
  type          = string
  default       = "northamerica-northeast1"
}

variable "gcp_zone" {
  description   = "Zone where the Google Cloud services are provisioned."
  type          = string
  default       = "northamerica-northeast1-a"
}

variable "gcp_gke_node_size" {
  description   = "Size of the GKE nodes."
  type          = string
  default       = "n2d-standard-4"
}