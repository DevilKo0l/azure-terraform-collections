locals {
  id = try(
    azurerm_windows_web_app.this[0].id,
    try(azurerm_linux_web_app.this[0].id, null)
  )

  name = try(
    azurerm_windows_web_app.this[0].name,
    try(azurerm_linux_web_app.this[0].name, null)
  )

  hostname = try(
    azurerm_windows_web_app.this[0].default_hostname,
    try(azurerm_linux_web_app.this[0].default_hostname, null)
  )

  principal_id = try(
    azurerm_windows_web_app.this[0].identity[0].principal_id,
    try(azurerm_linux_web_app.this[0].identity[0].principal_id, null)
  )
}

output "id" {
  value       = local.id
  description = "Web App resource ID"
}

output "name" {
  value       = local.name
  description = "Web App name"
}

output "default_hostname" {
  value       = local.hostname
  description = "Default hostname"
}

output "identity_principal_id" {
  value       = local.principal_id
  description = "Managed identity principal id (if enabled)"
}
