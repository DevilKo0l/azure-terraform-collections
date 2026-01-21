variable "environment" {
  description = "dev/qa/stg/prd"
  type        = string
}

variable "location" {
  description = "Azure region, e.g. westeurope"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "service_plan_id" {
  description = "App Service Plan ID"
  type        = string
}

variable "project_code" {
  description = "Project code, e.g. ETM"
  type        = string
}

variable "workload_id" {
  description = "Workload number, e.g. 0001"
  type        = string
}

variable "role" {
  description = "App role name, e.g. web, api"
  type        = string

  validation {
    condition     = length(trim(var.role)) > 0
    error_message = "role must be a non-empty string (e.g. web, api)."
  }
}

variable "name_prefix" {
  description = "Prefix for app name"
  type        = string
  default     = "app"
}

variable "os_type" {
  description = "windows or linux"
  type        = string

  validation {
    condition     = contains(["windows", "linux"], lower(var.os_type))
    error_message = "os_type must be 'windows' or 'linux'."
  }
}

variable "deploy_type" {
  description = "code or container"
  type        = string
  default     = "code"

  validation {
    condition     = contains(["code", "container"], lower(var.deploy_type))
    error_message = "deploy_type must be 'code' or 'container'."
  }
}

variable "https_only" {
  type    = bool
  default = true
}

variable "client_affinity_enabled" {
  type    = bool
  default = false
}

variable "always_on" {
  type    = bool
  default = true
}

variable "ftps_state" {
  description = "Disabled, FtpsOnly, AllAllowed"
  type        = string
  default     = "FtpsOnly"

  validation {
    condition     = contains(["Disabled", "FtpsOnly", "AllAllowed"], var.ftps_state)
    error_message = "ftps_state must be Disabled, FtpsOnly, or AllAllowed."
  }
}

variable "minimum_tls_version" {
  type    = string
  default = "1.2"
}

variable "app_settings" {
  description = "Do not store secrets here; use Key Vault references."
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

# Code stacks (optional)
variable "windows_application_stack" {
  description = "Used when os_type=windows AND deploy_type=code."
  type = object({
    current_stack  = optional(string) # e.g. "dotnet" or "node"
    dotnet_version = optional(string) # e.g. "v8.0"
    node_version   = optional(string) # e.g. "~20"
  })
  default = null
}

variable "linux_application_stack" {
  description = "Used when os_type=linux AND deploy_type=code."
  type = object({
    dotnet_version = optional(string) # e.g. "8.0"
    node_version   = optional(string) # e.g. "20-lts"
    python_version = optional(string) # e.g. "3.11"
    java_version   = optional(string) # e.g. "17"
  })
  default = null
}

# Container settings (primarily Linux; Windows container depends on plan/provider support)
variable "container" {
  description = "Used when deploy_type=container."
  type = object({
    image_name     = string
    registry_url   = optional(string) # e.g. https://myacr.azurecr.io
    username       = optional(string)
    password       = optional(string)

    # Linux: ACR pull via managed identity
    use_acr_mi     = optional(bool)
    uami_client_id = optional(string)
  })
  default = null
}

# Identity
variable "enable_system_assigned_identity" {
  type    = bool
  default = true
}

variable "user_assigned_identity_ids" {
  type    = list(string)
  default = []
}

variable "tags" {
  description = "Common/global tags from root"
  type        = map(string)
  default     = {}
}

# YAML overrides
variable "app_config" {
  description = "Decoded config.yaml content (yamldecode(file(...)))"
  type        = map(any)
  default     = {}
}

variable "config_env_key" {
  description = "Key used in config.yaml under environments (e.g. D0001-ETM). Root should derive this from folder name."
  type        = string
}
