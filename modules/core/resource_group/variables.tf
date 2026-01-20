variable "location" {
  type        = string
  description = "Azure region (e.g. westeurope)"
}

variable "name_prefix" {
  type        = string
  default     = "rg"
}

variable "workload_folder_name" {
  description = "Workload folder id like D0001-ABC / Q0001-ABC / S0001-ABC / P0001-ABC"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# --- NEW ---
variable "lock_in_prod_only" {
  description = "Automatically enable CanNotDelete lock only for prod (Pxxxx-*) workloads"
  type        = bool
  default     = true
}

# --- Optional manual override ---
variable "lock_override" {
  description = "Optional explicit lock override"
  type = object({
    enabled = bool
    level   = string
    notes   = string
  })
  default = null

  validation {
    condition = (
      var.lock_override == null ||
      contains(["CanNotDelete", "ReadOnly"], var.lock_override.level)
    )
    error_message = "lock_override.level must be CanNotDelete or ReadOnly."
  }
}