output "id" {
  description = "Virtual machine ID."
  value = coalesce(
    try(azurerm_linux_virtual_machine.this[0].id, null),
    try(azurerm_windows_virtual_machine.this[0].id, null)
  )
}

output "name" {
  description = "Virtual machine name."
  value = coalesce(
    try(azurerm_linux_virtual_machine.this[0].name, null),
    try(azurerm_windows_virtual_machine.this[0].name, null)
  )
}

output "private_ip_address" {
  description = "Private IP address."
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_id" {
  description = "Network interface ID."
  value       = azurerm_network_interface.this.id
}

output "public_ip_address" {
  description = "Public IP address."
  value       = try(azurerm_public_ip.this[0].ip_address, null)
}

output "principal_id" {
  description = "Managed identity principal ID."
  value = coalesce(
    try(azurerm_linux_virtual_machine.this[0].identity[0].principal_id, null),
    try(azurerm_windows_virtual_machine.this[0].identity[0].principal_id, null)
  )
}