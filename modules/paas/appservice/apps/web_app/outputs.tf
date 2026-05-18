output "id" {
  description = "Web App ID."
  value = coalesce(
    try(azurerm_linux_web_app.this[0].id, null),
    try(azurerm_windows_web_app.this[0].id, null)
  )
}

output "name" {
  description = "Web App name."
  value = coalesce(
    try(azurerm_linux_web_app.this[0].name, null),
    try(azurerm_windows_web_app.this[0].name, null)
  )
}

output "default_hostname" {
  description = "Default Web App hostname."
  value = coalesce(
    try(azurerm_linux_web_app.this[0].default_hostname, null),
    try(azurerm_windows_web_app.this[0].default_hostname, null)
  )
}

output "identity_principal_id" {
  description = "System-assigned identity principal ID."
  value = coalesce(
    try(azurerm_linux_web_app.this[0].identity[0].principal_id, null),
    try(azurerm_windows_web_app.this[0].identity[0].principal_id, null)
  )
}