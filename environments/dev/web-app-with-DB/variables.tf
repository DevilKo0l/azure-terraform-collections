# variable "app_service_plan" {
#   description = "The list of app service plans to be created"
#   type = any
# }
variable "sku_name" { 
    type = string
    default = "B1" 
}

variable "suffix" {
  type = string
  default = "0001"
}

variable "environment" {
  type = string
  description = "The environment name to be deployed"

  validation {
    condition = contains([
        "lab",
        "dev",
        "qa",
        "stg",
        "prd"
    ],var.environment)
    error_message = <<EOF
    Valid values for environment:
        "lab",
        "dev",
        "qa",
        "stg",
        "prd"
    EOF
  }
}
