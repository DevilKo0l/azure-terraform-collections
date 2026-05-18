locals {
  appservice_plan_config = try(
    local.workload_config.web.farm.app,
    {}
  )

  appservice_plan_name = "asp-${local.resource_suffix}-app"
}

module "app_service_plan" {
  source = "../../../modules/paas/appservice/plan"

  name                = local.appservice_plan_name
  location            = var.location
  resource_group_name = module.resource_group.name

  sku_name     = try(local.appservice_plan_config.sku_name, "B1")
  worker_count = try(local.appservice_plan_config.worker_count, 1)
  os_type      = "Windows"

  tags = local.common_tags
}