resource "azurerm_service_plan" "app_service_plan" {
  name = local.serverfarm_name
  resource_group_name = var.resource_group_name
  location = var.location
  tags = var.tags

  os_type = local.os_type
  sku_name = local.sku_name
  worker_count = local.worker_count
  per_site_scaling_enabled = local.per_site_scaling_enabled
}