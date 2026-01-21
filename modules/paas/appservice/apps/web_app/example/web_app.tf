module "web_windows" {
  source              = "../../../modules/paas/app_service/apps/web_app"
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name

  project_code   = local.project_code
  workload_id    = local.workload_id
  role           = "web"
  config_env_key = local.config_env_key

  # choose plan based on config
  service_plan_id = module.plan_win.id

  os_type     = "windows"
  deploy_type = "code"

  app_config = local.app_config
  tags       = local.common_tags
}

module "api_linux" {
  source              = "../../../modules/paas/app_service/apps/web_app"
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name

  project_code   = local.project_code
  workload_id    = local.workload_id
  role           = "api"
  config_env_key = local.config_env_key

  service_plan_id = module.plan_lin.id

  os_type     = "linux"
  deploy_type = "container"

  app_config = local.app_config
  tags       = local.common_tags
}