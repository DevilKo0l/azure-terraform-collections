resource "azurerm_resource_group" "this" {
  name     = local.name
  location = var.location
  tags     = local.merged_tags
}

resource "azurerm_management_lock" "rg" {
  count      = local.lock_enabled ? 1 : 0
  name       = "${azurerm_resource_group.this.name}-lock"
  scope      = azurerm_resource_group.this.id
  lock_level = local.lock_level
  notes      = local.lock_notes
}