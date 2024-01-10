variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "The ID of the Google Cloud Project where the GSA is created."
  type        = string
}

variable "name" {
  description = "The Name of the GSA."
  type        = string
}

variable "workload_identity" {
  description = "The information to enable Workload Identity on this GSA."
  type = object({
    gke_project_id  = string
    namespace       = string
    ksa             = string
  })
  sensitive = true
  default   = null
}

variable "roles" {
  description = "List of roles to assign to the GSA."
  type        = set(string)
  default     = []
}