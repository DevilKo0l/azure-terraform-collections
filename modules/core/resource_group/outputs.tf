output "id" {
  description = "Resource group id"
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "Resource group name"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Resource group location"
  value       = azurerm_resource_group.this.location
}

output "environment" {
  description = "Derived environment"
  value       = local.environment
}

output "project_code" {
  description = "Derived project code"
  value       = local.project_code
}

output "workload_id" {
  description = "Derived workload id (numeric)"
  value       = local.number_id
}