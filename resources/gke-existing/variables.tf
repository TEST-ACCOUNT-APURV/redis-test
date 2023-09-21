variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type = object({
    credentials = string
  })
  sensitive = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "gke_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "gke_cluster_location" {
  description = "Location of the GKE cluster"
  type        = string
}

variable "ip_address_name" {
  description = "Name of the puublic IP address"
  type        = string
}

variable "ip_address_region" {
  description = "Region of the puublic IP address"
  type        = string
}