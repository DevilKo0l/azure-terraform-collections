variable "config_path" {
  description = "Path (relative to this root stack) to the workload config.yaml. Example: configs/dev/D0001-ABC/config.yaml"
  type        = string
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription id to deploy into"
}

variable "location" {
  description = "Azure region (e.g. westeurope)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name (either pass it, or generate it in locals if you prefer)"
  type        = string
}