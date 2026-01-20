output "id" {
  description = "App Service Plan ID"
  value       = azurerm_service_plan.this.id
}

output "name" {
  description = "App Service Plan name"
  value       = azurerm_service_plan.this.name
}

output "environment" {
  description = "Derived environment (dev/qa/stg/prd)"
  value       = local.environment
}

output "project_code" {
  description = "Derived project code (ABC)"
  value       = local.project_code
}

output "workload_id" {
  description = "Derived workload numeric id (0001)"
  value       = local.number_id
}

output "sku_name" {
  description = "Resolved SKU name (after config overrides)"
  value       = local.final_sku_name
}

output "worker_count" {
  description = "Resolved worker count (after config overrides)"
  value       = local.final_worker_count
}