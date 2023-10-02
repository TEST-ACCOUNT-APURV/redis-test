variable "credentials" {
  description = "The credentials for connecting to Google Cloud."
  type        = map(any)
  sensitive   = true
}

variable "region" {
  description = "The Memorystore (Redis) region"
  type        = string
}

variable "network" {
  description = "The Memorystore (Redis) network"
  type        = string
  default     = "default"
}