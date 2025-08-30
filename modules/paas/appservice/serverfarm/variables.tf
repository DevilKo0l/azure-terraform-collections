variable "suffix" {
    description = "The suffix to be used to compose the resource name"
    type = string    
    default = "app"
}

variable "os_type" {
    description = "The OS type for APp services to be hosted in this plan. Posible values include Windows, Linux, and WIndowsContainer"
    type = string    
    default = "Windows"
}

variable "per_site_scaling_enabled" {
  description = "Should per-site scaling be enabled for this App Service Plan"
  type = bool
  default = false
}
variable "sku_name" {
    description = "The tier for app service plan"
    type = string    
    default = "B1"
    validation {
      condition = contains([
        "S1", "S2", "S3",
        "p1v2", "p2v2", "p3v2",
        "Y1", "EP1"
      ], var.sku_name)
      error_message = "The SKU name must be one of 'Standard' or 'PremiumV2'"
    }
}

variable "sku_capacity" {
  description = "The numbers of instances for the App Service Plan"
  type = number
  default = 2
  validation {
    condition = var.sku_capacity >= 1 && var.sku_capacity <=5
    error_message = "The SKU capacity must be between 1 and 5"
  }
}

variable "enable_diagnostics" {
  description = "Enable server farm diagnostics"
  type = bool
  default = false
}

variable "retention_days" {
  description = "The number of days to retain diagnostic logs"
  type = number
  default = 0
}

variable "tags" {
  type = map(string)
  default = {  
  }
}