locals {
  # config_path is relative to this root folder
  config_file = "${path.module}/${var.config_path}"

  app_config = yamldecode(file(local.config_file))

  # Get "D0001-EMT" from ".../D0001-EMT/config.yaml"
  workload_folder = basename(dirname(local.config_file))

  # Parse folder: D0001-EMT / Q0001-EMT / S0001-EMT / P0001-EMT
  wf = regex("^([DQSP])(\\d{4})-([A-Za-z0-9]+)$", local.workload_folder)

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

  common_tags = {
    environment  = local.environment
    project_code = local.project_code
    workload_id  = local.number_id
    workload_key = local.workload_folder
  }
}