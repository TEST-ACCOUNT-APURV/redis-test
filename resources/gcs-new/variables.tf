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
  description = "The GCS bucket region"
  type        = string
}