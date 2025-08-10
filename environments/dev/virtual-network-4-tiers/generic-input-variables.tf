#Generic Input Variables
# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastruction"
  type = string
  default = "sap"
}

#Environment Variable
variable "environment" {
  description = "Environment variable used as prefix"
  default = "dev"
}

#Azure Resource Group
variable "resource_group_name" {
  description = "Resource Group Name"
  default ="rg-default"
}

variable "resource_group_location" {
  description = "Region in which Azure Resouces to be created"
  default = "eastus2"
}