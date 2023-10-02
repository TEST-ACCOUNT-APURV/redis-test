variable "region" {
  description = "The Memorystore (Redis) region"
  type        = string
}

variable "network" {
  description = "The Memorystore (Redis) network"
  type        = string
  default     = "default"
}