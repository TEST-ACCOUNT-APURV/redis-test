variable "credentials" {
  description = "The credentials for connecting to Google Cloud"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID of the Google Cloud Project where the GSA is created"
  type        = string
}

variable "gke_project_id" {
  description = "ID of the Google Cloud Project of the GKE cluster (related to the Workload Identity setup)."
  type        = string
}

variable "namespace" {
  description = "The Kubernetes Namespace where the Workload and the Service Account are deployed"
  type        = string
}

variable "res_id" {
  description = "The ID of the resource (i.e. modules.workload-id.externals.resource-id)"
  type        = string
}

variable "ksa" {
  description = "The Name of the Kubernetes Service Account of the Workload"
  type        = string
}