output "id" {
  description = "Virtual Network ID."
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Virtual Network name."
  value       = azurerm_virtual_network.this.name
}

output "address_space" {
  description = "Virtual Network address space."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs."
  value = {
    for name, subnet in azurerm_subnet.this :
    name => subnet.id
  }
}

output "subnet_names" {
  description = "Subnet names."
  value       = keys(azurerm_subnet.this)
}