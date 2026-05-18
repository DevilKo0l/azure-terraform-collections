locals {
  name = var.name

  os_type = title(lower(var.os_type))

  sku_name = var.sku_name

  worker_count = var.worker_count

  per_site_scaling_enabled = var.per_site_scaling_enabled

  tags = merge(
    var.tags,
    {
      service   = "app_service"
      component = "plan"
    }
  )
}