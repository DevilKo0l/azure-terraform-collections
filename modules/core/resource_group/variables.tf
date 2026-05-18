variable "name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region where the resource group will be created."
  type        = string
}

variable "tags" {
  description = "Tags applied to the resource group."
  type        = map(string)
  default     = {}
}

variable "lock_enabled" {
  description = "Whether to create a management lock on the resource group."
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Management lock level."
  type        = string
  default     = "CanNotDelete"

  validation {
    condition = contains([
      "CanNotDelete",
      "ReadOnly"
    ], var.lock_level)

    error_message = "lock_level must be either 'CanNotDelete' or 'ReadOnly'."
  }
}

variable "lock_notes" {
  description = "Notes associated with the management lock."
  type        = string
  default     = "Protected resource group managed by Terraform."
}