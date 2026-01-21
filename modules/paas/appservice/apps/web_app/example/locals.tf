locals {
  # ----------------------------
  # Folder-driven identity
  # ----------------------------
  workload_folder = basename(path.module)  # D0001-ETM

  # Groups:
  # 1 = env_code (D/Q/S/P)
  # 2 = workload_id (0001)
  # 3 = project_code (ETM)
  wf = regex("^([A-Z])([0-9]{4})-([A-Z0-9]+)$", local.workload_folder)

  env_code     = local.wf[1]
  workload_id  = local.wf[2]
  project_code = local.wf[3]

  # Map env_code -> environment name
  environment_map = {
    D = "dev"
    Q = "qa"
    S = "stg"
    P = "prd"    
  }

  environment = lookup(local.environment_map, local.env_code, "unknown")

  # Used as key under config.yaml -> environments:
  config_env_key = local.workload_folder # D0001-ETM

  # ----------------------------
  # Load config.yaml
  # ----------------------------
  app_config = yamldecode(file("${path.module}/config.yaml"))

  # Convenient shortcuts
  farm_cfg = try(local.app_config["environments"][local.config_env_key]["web"]["farm"], {})
  web_cfg  = try(local.app_config["environments"][local.config_env_key]["web"]["web_app"], {})

  # plan_ref mapping for each role (web/api/...)
  web_plan_ref = lower(try(local.web_cfg["web"]["plan_ref"], "win"))
  api_plan_ref = lower(try(local.web_cfg["api"]["plan_ref"], "lin"))

  # Common tags to pass everywhere
  common_tags = {
    project     = local.project_code
    workload_id = local.workload_id
    env_code    = local.env_code
  }
}