variable "name" {
  description = "Network Security Group name."
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

variable "security_rules" {
  description = "NSG security rules."

  type = map(object({
    priority  = number
    direction = string
    access    = string
    protocol  = string

    source_port_range       = optional(string)
    source_port_ranges      = optional(list(string))
    destination_port_range  = optional(string)
    destination_port_ranges = optional(list(string))

    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))

  default = {}

  validation {
    condition = alltrue([
      for rule in values(var.security_rules) :
      contains(["Inbound", "Outbound"], rule.direction)
    ])
    error_message = "direction must be either Inbound or Outbound."
  }

  validation {
    condition = alltrue([
      for rule in values(var.security_rules) :
      contains(["Allow", "Deny"], rule.access)
    ])
    error_message = "access must be either Allow or Deny."
  }
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}