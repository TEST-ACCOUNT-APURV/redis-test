variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = map(any)
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "region" {
  description = "Region of the Google Cloud services"
  type        = string
}

variable "release_channel" {
  type    = string
  default = "RAPID"
}

variable "node_size" {
  description   = "Size of the GKE nodes."
  type          = string
  default       = "n2d-standard-4"
}

variable "existing_gar_repo_name" {
  description = "Name of the existing GAR repo to attach to GKE"
  type        = string
}