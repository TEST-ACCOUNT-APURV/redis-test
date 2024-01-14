variable "project_id" {
  description = "Atlas project id"
  type        = string
}

variable "public_key" {
  description = "Public API key to authenticate to Atlas"
  type        = string
}

variable "private_key" {
  description = "Private API key to authenticate to Atlas"
  type        = string
}

variable "provider_name" {
  description = "Atlas cluster provider name"
  default     = "TENANT"
  type        = string
}

variable "backing_provider_name" {
  description = "Atlas cluster backing provider name"
  default     = "GCP"
  type        = string
}

variable "region" {
  description = "Atlas cluster region"
  default     = "CENTRAL_US"
  type        = string
}

variable "cluster_version" {
  description = "Atlas cluster version"
  default     = "6.0"
  type        = string
}

variable "provider_instance_size_name" {
  description = "Atlas cluster provider instance name"
  default     = "M0"
  type        = string
}

variable "ip_access_list" {
  description = "List of the IP addresses to allow on the Atlas project."
  type        = set(string)
  default     = []
}