output "id" {
  description = "NSG ID."
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "NSG name."
  value       = azurerm_network_security_group.this.name
}

output "security_rule_names" {
  description = "Security rule names."
  value       = keys(azurerm_network_security_rule.this)
}