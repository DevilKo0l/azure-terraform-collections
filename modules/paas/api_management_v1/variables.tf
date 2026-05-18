variable "name" {
  description = "API Management service name."
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

variable "publisher_name" {
  description = "APIM publisher name."
  type        = string
}

variable "publisher_email" {
  description = "APIM publisher email."
  type        = string
}

variable "sku_name" {
  description = "APIM SKU name. Examples: Developer_1, Basic_1, Standard_1, Premium_1."
  type        = string
  default     = "Developer_1"

  validation {
    condition = can(regex(
      "^(Developer|Basic|Standard|Premium)_[0-9]+$",
      var.sku_name
    ))

    error_message = "sku_name must look like Developer_1, Basic_1, Standard_1, or Premium_1."
  }
}

variable "virtual_network_type" {
  description = "APIM virtual network mode. Use None, External, or Internal."
  type        = string
  default     = "None"

  validation {
    condition = contains([
      "none",
      "external",
      "internal"
    ], lower(var.virtual_network_type))

    error_message = "virtual_network_type must be one of: None, External, Internal."
  }
}

variable "subnet_id" {
  description = "Subnet ID for APIM VNet injection. Required when virtual_network_type is Internal or External."
  type        = string
  default     = null

  validation {
    condition = (
      contains(["internal", "external"], lower(var.virtual_network_type))
      ? var.subnet_id != null && var.subnet_id != ""
      : true
    )

    error_message = "subnet_id is required when virtual_network_type is Internal or External."
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for APIM."
  type        = bool
  default     = true
}

variable "client_certificate_enabled" {
  description = "Whether client certificate is enabled for the gateway."
  type        = bool
  default     = false
}

variable "min_api_version" {
  description = "Minimum API version supported by APIM."
  type        = string
  default     = "2019-12-01"
}

variable "identity_type" {
  description = "Managed identity type."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition = contains([
      "SystemAssigned",
      "UserAssigned",
      "SystemAssigned, UserAssigned"
    ], var.identity_type)

    error_message = "identity_type must be SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

variable "identity_ids" {
  description = "User-assigned managed identity IDs."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}