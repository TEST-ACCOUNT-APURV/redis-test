variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = map(any)
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "location" {
  description = "The Cloud SQL location"
  type        = string
}

variable "database_version" {
  description = "The Cloud SQL Database version"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "The Cloud SQL tier"
  type        = string
  default     = "db-f1-micro"
}