variable "asset_tag" {
  description = "The asset_tag for environment name to be deployed"
  type = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the app service plan should be created"
  type = string
}

variable "location" {
  description = "The azure region to be used to deploy"
  type = string
  default = "westeurope"
}