locals {
  # Optional location shortening for naming
  location_map = {
    "westeurope"    = "weu"
    "northeurope"   = "neu"
    "swedencentral" = "swc"
  }

  loc_code = lookup(local.location_map, lower(var.location), "loc")

  # ----------------------------
  # config.yaml override lookup
  # ----------------------------
  # Expected YAML shape:
  #
  # environments:
  #   D1234:
  #     web:
  #       farm:
  #         app:
  #           sku_name: P1v3
  #           worker_count: 2
  #           os_type: Linux
  #
  cfg = try(
    var.app_config["environments"][var.application_id]["web"]["farm"][var.suffix],
    {}
  )

  # Final resolved values
  final_os_type = coalesce(
    try(local.cfg["os_type"], null),
    var.os_type
  )

  final_sku_name = coalesce(
    try(local.cfg["sku_name"], null),
    var.sku_name
  )

  final_worker_count = coalesce(
    try(local.cfg["worker_count"], null),
    var.worker_count
  )

  final_per_site_scaling_enabled = coalesce(
    try(local.cfg["per_site_scaling_enabled"], null),
    var.per_site_scaling_enabled
  )

  # ----------------------------
  # Naming
  # Example: asp-dev-weu-d1234-app
  # ----------------------------
  name = lower(format(
    "%s-%s-%s-%s-%s",
    var.name_prefix,
    var.environment,
    local.loc_code,
    var.application_id,
    var.suffix
  ))

  # ----------------------------
  # Tags (enforced + global)
  # ----------------------------
  merged_tags = merge(
    var.tags,
    {
      application_id = var.application_id
      environment    = var.environment
      service        = "app_service"
      component      = "plan"
    }
  )
}