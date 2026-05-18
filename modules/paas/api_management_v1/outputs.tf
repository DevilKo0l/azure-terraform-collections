output "id" {
  description = "APIM ID."
  value       = azurerm_api_management.this.id
}

output "name" {
  description = "APIM name."
  value       = azurerm_api_management.this.name
}

output "gateway_url" {
  description = "APIM gateway URL."
  value       = azurerm_api_management.this.gateway_url
}

output "management_api_url" {
  description = "APIM management API URL."
  value       = azurerm_api_management.this.management_api_url
}

output "portal_url" {
  description = "APIM developer portal URL."
  value       = azurerm_api_management.this.portal_url
}

output "scm_url" {
  description = "APIM SCM URL."
  value       = azurerm_api_management.this.scm_url
}

output "identity_principal_id" {
  description = "System-assigned identity principal ID."
  value       = try(azurerm_api_management.this.identity[0].principal_id, null)
}