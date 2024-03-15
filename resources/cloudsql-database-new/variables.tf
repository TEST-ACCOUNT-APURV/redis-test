variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "instance_name" {
  description = "The Cloud SQL Instance name"
  type        = string
}

variable "port" {
  description = "The Cloud SQL Instance port"
  type        = number
  default     = 5432
}

variable "username" {
  description = "The Cloud SQL Instance username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "The Cloud SQL Instance password"
  type        = string
  sensitive   = true
}