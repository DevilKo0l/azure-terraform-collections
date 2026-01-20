module "app_service_plan" {
  source              = "./modules/app_service/plan"
  application_id      = "E1234"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"

  # defaults (used if config.yaml has no override)
  os_type      = "windows"
  sku_name     = "B1"
  worker_count = 1

  # overrides from YAML
  app_config = local.app_config

  tags = {
    owner = "platform-team"
  }
}