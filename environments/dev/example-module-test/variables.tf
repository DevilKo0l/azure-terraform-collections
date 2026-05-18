variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "config_path" {
  description = "Path to config.yaml."
  type        = string
}

variable "target_workload" {
  description = "Target workload key from config.yaml. Example: D0001-EMT."
  type        = string
}