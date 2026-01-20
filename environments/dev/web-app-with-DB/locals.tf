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

  serverfarm_name = lower(format(
    #asp-dw-projname-0001
    "asp-%s%s-%s-%s",
    substr(var.asset_tag,0,1), #letter for the environment
    local.location_map[var.location],    
    substr(var.asset_tag,1,4),
    var.suffix,
  ))  
}