locals {
  webapp_config = try(
    local.workload_config.web.app.web,
    {}
  )

  webapp_name = "app-${local.resource_suffix}-web"
}

module "windows_webapp" {
  source = "../../../modules/paas/appservice/apps/web_app"

  name                = local.webapp_name
  role                = "web"
  location            = var.location
  resource_group_name = module.resource_group.name
  service_plan_id     = module.app_service_plan.id

  os_type     = "windows"
  deploy_type = try(local.webapp_config.deploy_type, "code")

  https_only          = try(local.webapp_config.https_only, true)
  always_on           = try(local.webapp_config.always_on, true)
  ftps_state          = try(local.webapp_config.ftps_state, "Disabled")
  minimum_tls_version = try(local.webapp_config.minimum_tls_version, "1.2")

  app_settings = try(local.webapp_config.app_settings, {})

  tags = local.common_tags
}