output "id" {
  description = "App Service Plan ID"
  value       = azurerm_service_plan.this.id
}

output "name" {
  description = "App Service Plan name"
  value       = azurerm_service_plan.this.name
}

output "sku_name" {
  description = "Resolved SKU name"
  value       = local.final_sku_name
}

output "worker_count" {
  description = "Resolved worker count"
  value       = local.final_worker_count
}