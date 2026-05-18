variable "name" {
  description = "Virtual Network name."
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

variable "address_space" {
  description = "Virtual Network address space."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "address_space must contain at least one CIDR block."
  }
}

variable "dns_servers" {
  description = "Custom DNS servers."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Subnets to create inside the virtual network."

  type = map(object({
    address_prefixes = list(string)

    service_endpoints = optional(list(string), [])

    delegations = optional(map(object({
      service_name = string
      actions      = optional(list(string), [])
    })), {})
  }))

  default = {}
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}