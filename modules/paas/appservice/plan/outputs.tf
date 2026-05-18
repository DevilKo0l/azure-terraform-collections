output "id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.this.id
}

output "name" {
  description = "The name of the App Service Plan."
  value       = azurerm_service_plan.this.name
}

output "location" {
  description = "The location of the App Service Plan."
  value       = azurerm_service_plan.this.location
}

output "resource_group_name" {
  description = "The resource group name of the App Service Plan."
  value       = azurerm_service_plan.this.resource_group_name
}

output "os_type" {
  description = "The OS type of the App Service Plan."
  value       = azurerm_service_plan.this.os_type
}

output "sku_name" {
  description = "The SKU name of the App Service Plan."
  value       = azurerm_service_plan.this.sku_name
}

output "worker_count" {
  description = "The worker count of the App Service Plan."
  value       = azurerm_service_plan.this.worker_count
}