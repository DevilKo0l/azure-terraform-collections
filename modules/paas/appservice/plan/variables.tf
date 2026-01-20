variable "application_id" {
  description = "Business/workload identifier (recommended). Example: D1234"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name, e.g. dev/qa/stg/prd. Optional if you derive from app id; recommended to pass explicitly from root."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region (e.g., westeurope)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the plan is created"
  type        = string
}

variable "suffix" {
  description = "Suffix used for config override lookup + name uniqueness (e.g., app/api/worker)."
  type        = string
  default     = "app"
}

variable "name_prefix" {
  description = "Prefix for resource naming. Default 'asp' = App Service Plan."
  type        = string
  default     = "asp"
}

variable "os_type" {
  description = "Plan OS type: Windows, Linux, WindowsContainer"
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Windows", "Linux", "WindowsContainer"], var.os_type)
    error_message = "os_type must be one of: Windows, Linux, WindowsContainer."
  }
}

variable "sku_name" {
  description = "Plan SKU name (e.g., B1, S1, P1v3)."
  type        = string
  default     = "B1"
}

variable "worker_count" {
  description = "Number of instances."
  type        = number
  default     = 1

  validation {
    condition     = var.worker_count >= 1 && var.worker_count <= 20
    error_message = "worker_count must be between 1 and 20."
  }
}

variable "sku_capacity" {
  description = "Legacy alias for worker_count (deprecated)."
  type        = number
  default     = null
}

variable "per_site_scaling_enabled" {
  description = "Enable per-site scaling."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the plan. Root should pass global/common tags."
  type        = map(string)
  default     = {}
}

variable "app_config" {
  description = "Decoded YAML config map. Root should yamldecode(file(...)) and pass it in."
  type        = map(any)
  default     = {}
}