variable "location" {
  description = "Azure region (e.g., westeurope)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the plan is created"
  type        = string
}

variable "suffix" {
  description = "Suffix used for config lookup and naming (app/api/worker)."
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

# Optional escape hatches (recommended to keep, rarely used)
variable "workload_folder_name" {
  description = "Override workload folder name (default = basename(path.cwd)). Expected: D0001 / Q0001 / S0001 / P0001 (optional -ABC)."
  type        = string
  default     = null
}

variable "project_code_override" {
  description = "Override derived project code (ABC). Default derives from project folder name axxx-bxx-cxxx => ABC."
  type        = string
  default     = null
}