variable "name" {
  description = "App Service Plan name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "os_type" {
  description = "Plan OS type."
  type        = string
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows", "WindowsContainer"], var.os_type)
    error_message = "os_type must be one of: Linux, Windows, WindowsContainer."
  }
}

variable "sku_name" {
  description = "App Service Plan SKU."
  type        = string
  default     = "B1"
}

variable "worker_count" {
  description = "Number of workers."
  type        = number
  default     = 1

  validation {
    condition     = var.worker_count >= 1
    error_message = "worker_count must be greater than or equal to 1."
  }
}

variable "per_site_scaling_enabled" {
  description = "Enable per-site scaling."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}