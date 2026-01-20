resource "azurerm_service_plan" "this" {
  name                = local.name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type                  = local.final_os_type
  sku_name                 = local.final_sku_name
  worker_count             = local.final_worker_count
  per_site_scaling_enabled = local.final_per_site_scaling_enabled

  tags = local.merged_tags

  # Uncomment ONLY if tags are managed externally:
  # lifecycle { ignore_changes = [tags] }
}