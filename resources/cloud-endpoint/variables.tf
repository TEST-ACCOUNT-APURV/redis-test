variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project."
  type        = string
}

variable "ip_address" {
  description = "The IP address of the Cloud Endpoint."
  type        = string
}

variable "dns_prefix" {
  description = "The prefix of the Cloud Endpoint."
  type        = string
}