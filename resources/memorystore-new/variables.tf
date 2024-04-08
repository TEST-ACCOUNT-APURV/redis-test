variable "credentials" {
description = "GCP credentials"
type = map
default = {
"store" = "your-gsm-2-secret-store"
"ref" = "svc-gcp-tf-48hours"
}
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
