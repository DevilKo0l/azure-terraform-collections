locals {
  location_map = {
    "westeurope"    = "weu"
    "northeurope"   = "neu"
    "swedencentral" = "swc"
  }
  loc_code = lookup(local.location_map, lower(var.location), "loc")

  # Try a few possible YAML shapes to be flexible:
  # 1) environments.<key>.web.web_app.<role>
  # 2) environments.<key>.web.<role>
  # 3) environments.<key>.app_service.web_app.<role>
  cfg = coalesce(
    try(var.app_config["environments"][var.config_env_key]["web"]["web_app"][var.role], null),
    try(var.app_config["environments"][var.config_env_key]["web"][var.role], null),
    try(var.app_config["environments"][var.config_env_key]["app_service"]["web_app"][var.role], null),
    {}
  )

  final_os_type     = lower(coalesce(try(local.cfg["os_type"], null), var.os_type))
  final_deploy_type = lower(coalesce(try(local.cfg["deploy_type"], null), var.deploy_type))

  final_https_only             = coalesce(try(local.cfg["https_only"], null), var.https_only)
  final_client_affinity        = coalesce(try(local.cfg["client_affinity_enabled"], null), var.client_affinity_enabled)
  final_always_on              = coalesce(try(local.cfg["always_on"], null), var.always_on)
  final_ftps_state             = coalesce(try(local.cfg["ftps_state"], null), var.ftps_state)
  final_min_tls                = coalesce(try(local.cfg["minimum_tls_version"], null), var.minimum_tls_version)

  final_app_settings = merge(
    var.app_settings,
    try(local.cfg["app_settings"], {})
  )

  final_connection_strings = coalesce(
    try(local.cfg["connection_strings"], null),
    var.connection_strings
  )

  final_container = coalesce(
    try(local.cfg["container"], null),
    var.container
  )

  # Name: app-dev-weu-ETM-0001-web (or api)
  name = lower(format(
    "%s-%s-%s-%s-%s-%s",
    var.name_prefix,
    var.environment,
    local.loc_code,
    var.project_code,
    var.workload_id,
    var.role
  ))

  merged_tags = merge(
    var.tags,
    {
      environment = var.environment
      project     = var.project_code
      workload_id = var.workload_id
      role        = var.role
      service     = "app_service"
      component   = "web_app"
      os_type     = local.final_os_type
      deploy_type = local.final_deploy_type
    }
  )

  identity_type = (
    var.enable_system_assigned_identity && length(var.user_assigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" :
    var.enable_system_assigned_identity ? "SystemAssigned" :
    length(var.user_assigned_identity_ids) > 0 ? "UserAssigned" :
    null
  )

  create_windows = local.final_os_type == "windows"
  create_linux   = local.final_os_type == "linux"
}
