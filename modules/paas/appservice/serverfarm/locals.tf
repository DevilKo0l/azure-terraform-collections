locals {
  environment_map = {
    "L" = "lab"
    "D" = "dev"
    "Q" = "qa"
    "S" = "stg"
    "P" = "prd"
  }

  location_map = {
    "westeurope"    = "w"
    "northeurope"   = "n"
    "swedencentral" = "s"
  }

  enviironment = local.environment_map[substr(var.asset_tag, 0,1)]

  serverfarm_name = lower(formet(
    #asp-dw-projname-0001
    "asp-%s%s-%s-%s-%s",
    substr(var.asset_tag,0,1), #letter for the environment
    local.location_map[var.location],
    var.app_config["name"],
    substr(var.asset_tag,1,4),
    var.suffix,
  ))

  os_type                   = coalesce(try(var.app_config["environments"][var.asset_tag]["web"]["farm"]["$(var.suffix)"]["os_type"],null),var.os_type)
  sku_name                  = coalesce(try(var.app_config["environments"][var.asset_tag]["web"]["farm"]["$(var.suffix)"]["sku_name"],null),var.sku_name)
  worker_count              = coalesce(try(var.app_config["environments"][var.asset_tag]["web"]["farm"]["$(var.suffix)"]["sku_capacity"],null),var.sku_capacity)
  per_site_scaling_enabled  = coalesce(try(var.app_config["environments"][var.asset_tag]["web"]["farm"]["$(var.suffix)"]["per_site_scaling_enabled"],null),var.per_site_scaling_enabled)
}