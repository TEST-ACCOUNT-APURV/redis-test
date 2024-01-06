variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project"
  type        = string
}

variable "namespace" {
  description = "The Kubernetes Namespace where the Workload and the Service Account are deployed"
  type        = string
}

variable "workload" {
  description = "The Name of the Workload"
  type        = string
}

variable "ksa" {
  description = "The Name of the Kubernetes Service Account of the Workload"
  type        = string
}

variable "roles" {
  description = "List of roles to assign to the Google service account"
  type        = set(string)
  default     = []
}