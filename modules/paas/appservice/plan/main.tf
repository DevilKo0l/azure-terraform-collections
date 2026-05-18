resource "azurerm_service_plan" "this" {
  name                = local.name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type                  = local.os_type
  sku_name                 = local.sku_name
  worker_count             = local.worker_count
  per_site_scaling_enabled = local.per_site_scaling_enabled

  tags = local.tags
}