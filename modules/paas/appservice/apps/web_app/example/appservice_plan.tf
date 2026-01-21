module "plan_win" {
  source              = "../../../modules/paas/app_service/plan"
  application_id      = "unused" # if your plan module still requires it, remove it from module and use project_code/workload_id too
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name

  suffix     = "win" # used for config lookup (farm.win)
  app_config  = local.app_config
  tags        = local.common_tags
}

module "plan_lin" {
  source              = "../../../modules/paas/app_service/plan"
  application_id      = "unused"
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name

  suffix     = "lin" # used for config lookup (farm.lin)
  app_config  = local.app_config
  tags        = local.common_tags
}