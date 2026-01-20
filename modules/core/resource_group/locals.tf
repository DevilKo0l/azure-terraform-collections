locals {
  # Parse workload folder: D0001-ABC / Q0001-ABC / S0001-ABC / P0001-ABC
  wf = regex("^([DQSP])(\\d{4})-([A-Za-z0-9]+)$", var.workload_folder_name)

  env_code     = local.wf[0]
  number_id    = local.wf[1]
  project_code = upper(local.wf[2])

  env_map = {
    D = "dev"
    Q = "qa"
    S = "stg"
    P = "prd"
  }

  environment = lookup(local.env_map, local.env_code, "unknown")

  location_map = {
    "westeurope"    = "weu"
    "northeurope"   = "neu"
    "swedencentral" = "swc"
  }

  loc_code = lookup(local.location_map, lower(var.location), "loc")

  # RG name: rg-dev-weu-ABC-0001
  name = format(
    "%s-%s-%s-%s-%s",
    lower(var.name_prefix),
    lower(local.environment),
    lower(local.loc_code),
    local.project_code,
    local.number_id
  )

  merged_tags = merge(
    var.tags,
    {
      environment  = local.environment
      project_code = local.project_code
      workload_id  = local.number_id
      workload_key = var.workload_folder_name
      component    = "resource_group"
    }
  )

  # ----------------------------
  # Lock logic (THIS is the key)
  # ----------------------------

  # Auto-lock only when:
  # - lock_in_prod_only = true
  # - env_code == "P"
  auto_lock_enabled = var.lock_in_prod_only && local.env_code == "P"

  # Final lock decision:
  lock_enabled = (
    var.lock_override != null
    ? var.lock_override.enabled
    : local.auto_lock_enabled
  )

  lock_level = (
    var.lock_override != null
    ? var.lock_override.level
    : "CanNotDelete"
  )

  lock_notes = (
    var.lock_override != null
    ? var.lock_override.notes
    : "Protected prod resource group"
  )
}