variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
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

variable "instance_deletion_protection" {
  description = "The Cloud SQL instance deletion protection"
  type        = bool
  default     = true
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

variable "private_network" {
  description = "The Cloud SQL private network (VPC)"
  type        = string
}

variable "port" {
  description = "The Cloud SQL Instance port"
  type        = number
  default     = 5432
}