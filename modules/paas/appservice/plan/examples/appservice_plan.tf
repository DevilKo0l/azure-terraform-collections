module "app_service_plan" {
  source = "../../../modules/paas/appservice/plan"

  location            = var.location
  #You need to have resourcegroup plan deploy as well
  resource_group_name = module.rg.name

  app_config = local.app_config
  tags       = local.common_tags

  # IMPORTANT for Option B:
  workload_folder_name = local.workload_folder
}