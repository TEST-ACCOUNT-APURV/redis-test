variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = object({
    type                        = string
    project_id                  = string
    private_key_id              = string
    private_key                 = string
    client_email                = string
    client_id                   = string
    auth_uri                    = string
    token_uri                   = string
    auth_provider_x509_cert_url = string
    client_x509_cert_url        = string
    universe_domain             = string
  })
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "gke_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "gke_location" {
  description = "Location of the GKE cluster"
  type        = string
}

variable "ip_address_name" {
  description = "Name of the public IP address"
  type        = string
}

variable "ip_address_region" {
  description = "Region of the public IP address"
  type        = string
}