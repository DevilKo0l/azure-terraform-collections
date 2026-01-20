locals {
  # ----------------------------
  # 1) Read folder names
  # ----------------------------
  workload_folder = coalesce(var.workload_folder_name, basename(path.cwd))
  project_folder  = basename(dirname(path.cwd))

  # ----------------------------
  # 2) Derive project code from project folder name
  #    Example: axxxx-bxxx-cxxxx => ABC
  # ----------------------------
  project_parts = split("-", local.project_folder)

  derived_project_code = upper(join("", [
    for p in local.project_parts : substr(p, 0, 1)
    if length(p) > 0
  ]))

  # ----------------------------
  # 3) Parse workload folder
  #    Supported:
  #      D0001
  #      D0001-ABC (optional explicit code)
  #      Q0001
  #      S0001
  #      P0001
  #
  # Regex groups:
  #   1 = env_code (D/Q/S/P)
  #   2 = number_id (0001)
  #   3 = optional explicit code
  # ----------------------------
  wf = regex("^([DQSP])(\\d{4})(?:-([A-Za-z0-9]+))?$", local.workload_folder)

  env_code          = local.wf[0]
  number_id         = local.wf[1]
  code_from_workdir = try(local.wf[2], null)

  env_map = {
    D = "dev"
    Q = "qa"
    S = "stg"
    P = "prd"
  }

  environment = lookup(local.env_map, local.env_code, "unknown")

  # Final project code priority:
  # 1) explicit override (var.project_code_override)
  # 2) explicit code in workload folder (D0001-ABC)
  # 3) derived from project folder (axxx-bxx-cxx => ABC)
  project_code = upper(coalesce(
    var.project_code_override,
    local.code_from_workdir,
    local.derived_project_code
  ))

  # Key for legacy YAML shape (if you still use environments: <key>: ...)
  config_env_key = format("%s%s-%s", local.env_code, local.number_id, local.project_code)

  # ----------------------------
  # 4) Location short code
  # ----------------------------
  location_map = {
    "westeurope"    = "weu"
    "northeurope"   = "neu"
    "swedencentral" = "swc"
  }

  loc_code = lookup(local.location_map, lower(var.location), "loc")

  # ----------------------------
  # 5) Read config overrides
  #
  # Recommended per-workload config.yaml (simple):
  # web:
  #   farm:
  #     app:
  #       sku_name: B1
  #
  # Backward compatible legacy shape:
  # environments:
  #   D0001-ABC:
  #     web:
  #       farm:
  #         app: { ... }
  # ----------------------------
  cfg_simple = try(var.app_config["web"]["farm"][var.suffix], null)
  cfg_legacy = try(var.app_config["environments"][local.config_env_key]["web"]["farm"][var.suffix], null)

  cfg = coalesce(local.cfg_simple, local.cfg_legacy, {})

  final_os_type = coalesce(try(local.cfg["os_type"], null), var.os_type)
  final_sku_name = coalesce(try(local.cfg["sku_name"], null), var.sku_name)
  final_worker_count = coalesce(try(local.cfg["worker_count"], null), var.worker_count)
  final_per_site_scaling_enabled = coalesce(
    try(local.cfg["per_site_scaling_enabled"], null),
    var.per_site_scaling_enabled
  )

  # ----------------------------
  # 6) Naming
  # Example: asp-dev-weu-ABC-0001-app
  # Keep code uppercase, rest lower.
  # ----------------------------
  name = format(
    "%s-%s-%s-%s-%s-%s",
    lower(var.name_prefix),
    lower(local.environment),
    lower(local.loc_code),
    local.project_code,
    local.number_id,
    lower(var.suffix)
  )

  # ----------------------------
  # 7) Tags (enforced + global)
  # ----------------------------
  merged_tags = merge(
    var.tags,
    {
      environment  = local.environment
      env_code     = local.env_code
      project_code = local.project_code
      workload_id  = local.number_id
      service      = "app_service"
      component    = "plan"
    }
  )
}