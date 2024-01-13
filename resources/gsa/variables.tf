variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "The ID of the Google Cloud Project where the GSA is created."
  type        = string
}

variable "res_id" {
  description = "The ID of the resource (i.e. modules.workload-id.externals.resource-id)."
  type        = string
}

variable "workload_identity" {
  description = "The information to enable Workload Identity on this GSA."
  type = object({
    gke_project_id  = string
    namespace       = string
  })
  sensitive = true
  default   = null
}

variable "iam_member_resource_names" {
  description = "List of resource names for the IAM Role bindings to assign to the GSA."
  type        = list(string)
  default     = []
}

variable "iam_member_roles" {
  description = "List of roles for the IAM Role bindings to assign to the GSA."
  type        = list(string)
  default     = []
}