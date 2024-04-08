variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
  sensitive   = true
}


variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "region" {
  description = "The Memorystore (Redis) region"
  type        = string
}

variable "network" {
  description = "The Memorystore (Redis) network"
  type        = string
  default     = "default"
}
