variable "location" {
    default = "West Europe"
    type = string 
}

variable "resource_group_name" { 
    type = string 
}

variable "sku_name" { 
    type = string 
}

variable "env" {
    default = "dev"
}

variable "ftps_state" {
    default = true
}

variable "minimum_tls_version" {
    default = true
}