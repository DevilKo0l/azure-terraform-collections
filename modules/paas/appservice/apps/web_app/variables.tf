variable "name" {
  description = "Web App name."
  type        = string
}

variable "role" {
  description = "Web App role, for example web, api, or worker."
  type        = string
  default     = "web"
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "service_plan_id" {
  description = "App Service Plan ID."
  type        = string
}

variable "os_type" {
  description = "Web App OS type."
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "os_type must be either linux or windows."
  }
}

variable "deploy_type" {
  description = "Deployment type. Use code or container."
  type        = string
  default     = "code"

  validation {
    condition     = contains(["code", "container"], lower(var.deploy_type))
    error_message = "deploy_type must be either code or container."
  }
}

variable "https_only" {
  description = "Require HTTPS only."
  type        = bool
  default     = true
}

variable "always_on" {
  description = "Keep the Web App always on."
  type        = bool
  default     = true
}

variable "ftps_state" {
  description = "FTPS state."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["AllAllowed", "FtpsOnly", "Disabled"], var.ftps_state)
    error_message = "ftps_state must be AllAllowed, FtpsOnly, or Disabled."
  }
}

variable "minimum_tls_version" {
  description = "Minimum TLS version."
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.2", "1.3"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be 1.2 or 1.3."
  }
}

variable "app_settings" {
  description = "App settings."
  type        = map(string)
  default     = {}
}

variable "enable_system_assigned_identity" {
  description = "Enable system-assigned managed identity."
  type        = bool
  default     = true
}

variable "user_assigned_identity_ids" {
  description = "User-assigned managed identity IDs."
  type        = list(string)
  default     = []
}

variable "container_image_name" {
  description = "Container image name, for example nginx:latest."
  type        = string
  default     = null
}

variable "container_registry_url" {
  description = "Container registry URL, for example https://myregistry.azurecr.io."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}