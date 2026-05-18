resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = local.tags
}

resource "azurerm_management_lock" "this" {
  count = var.lock_enabled ? 1 : 0

  name       = "${azurerm_resource_group.this.name}-lock"
  scope      = azurerm_resource_group.this.id
  lock_level = var.lock_level
  notes      = var.lock_notes
}