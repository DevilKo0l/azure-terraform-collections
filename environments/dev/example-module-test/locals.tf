locals {
  # =========================================================
  # 0) Config file location (robust, copy-paste friendly)
  # =========================================================
  # Default: config.yaml lives in the same folder as this stack.
  # Optional override: var.config_path (relative to stack folder).
  config_path = coalesce(try(var.config_path, null), "config.yaml")
  config_file = abspath("${path.module}/${local.config_path}")

  # Decode only if exists (checks below will enforce existence)
  app_config = fileexists(local.config_file) ? yamldecode(file(local.config_file)) : {}

  # =========================================================
  # 1) Workload identity derived from folder name
  # =========================================================
  # Derive from folder containing config.yaml (most reliable anchor).
  # Folder expected: D0001-ETM / Q0001-ETM / S0001-ETM / P0001-ETM
  workload_folder = basename(dirname(local.config_file)) # e.g., D0001-ETM

  wf_matches = regexall("^([DQSP])([0-9]{4})-([A-Za-z0-9]+)$", local.workload_folder)

  env_code     = try(local.wf_matches[0][0], null)                # D/Q/S/P
  workload_id  = try(local.wf_matches[0][1], null)                # 0001
  project_code = try(upper(local.wf_matches[0][2]), null)         # ETM

  # =========================================================
  # 2) Environment mapping (platform contract)
  # =========================================================
  environment_map = {
    D = "dev"
    Q = "qa"
    S = "stg"
    P = "prd"
  }

  environment = local.env_code != null ? lookup(local.environment_map, local.env_code, "unknown") : "unknown"

  # =========================================================
  # 3) Standard key used in config.yaml
  # =========================================================
  # config.yaml:
  # environments:
  #   D0001-ETM:
  config_env_key = local.workload_folder

  # =========================================================
  # 4) Handy config shortcuts (safe even if keys don't exist)
  # =========================================================
  # These are OPTIONAL conveniences. They never break stacks
  # that don't have these sections in YAML.
  farm_cfg = try(local.app_config["environments"][local.config_env_key]["web"]["farm"], {})
  web_cfg  = try(local.app_config["environments"][local.config_env_key]["web"]["web_app"], {})

  # Optional plan selection by role (web/api/...), safe defaults
  web_plan_ref = lower(try(local.web_cfg["web"]["plan_ref"], "app"))
  api_plan_ref = lower(try(local.web_cfg["api"]["plan_ref"], "app"))

  # =========================================================
  # 5) Common tags (pass to ALL modules)
  # =========================================================
  common_tags = {
    environment  = local.environment
    project_code = coalesce(local.project_code, "unknown")
    workload_id  = coalesce(local.workload_id, "unknown")
    workload_key = local.workload_folder
    env_code     = coalesce(local.env_code, "unknown")
  }
}

# =========================================================
# 6) Fail-fast checks with clear errors (Terraform 1.5+)
# =========================================================
check "config_file_exists" {
  assert {
    condition     = fileexists(local.config_file)
    error_message = "Missing config file at '${local.config_file}'. Put config.yaml in the stack folder or set var.config_path."
  }
}

check "workload_folder_format" {
  assert {
    condition     = length(local.wf_matches) > 0
    error_message = "Stack folder must be like 'D0001-ETM' (D/Q/S/P + 4 digits + '-' + project). Current: '${local.workload_folder}'."
  }
}

check "env_code_supported" {
  assert {
    condition     = local.env_code != null && contains(keys(local.environment_map), local.env_code)
    error_message = "Unsupported env code '${local.env_code}'. Allowed: ${join(", ", keys(local.environment_map))}."
  }
}