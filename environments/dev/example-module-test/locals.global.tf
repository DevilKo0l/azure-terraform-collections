locals {
  #
  # ---------------------------------------------------------
  # Configuration
  # ---------------------------------------------------------
  #

  config_file = var.config_path

  config = fileexists(local.config_file) ? yamldecode(file(local.config_file)) : {}

  workload_key = var.target_workload

  workload_config = try(
    local.config.environments[local.workload_key],
    {}
  )

  #
  # ---------------------------------------------------------
  # Workload parsing
  # Format: <ENV><4 digits>-<PROJECT_CODE>
  # Example: D0001-EMT
  # ---------------------------------------------------------
  #

workload_match = regexall(
  "^([DTSP])([0-9]{4})-([A-Za-z0-9]+)$",
  local.workload_key
)[0]

  env_code = local.workload_match[0]

  workload_id = local.workload_match[1]

  project_code = upper(local.workload_match[2])

  #
  # ---------------------------------------------------------
  # Environment mapping
  # ---------------------------------------------------------
  #

  env_map = {
    D = "dev"
    T = "test"
    S = "stg"
    P = "prd"
  }

  environment = local.env_map[local.env_code]

  #
  # ---------------------------------------------------------
  # Location mapping
  # ---------------------------------------------------------
  #

  location_short_map = {
    westeurope   = "weu"
    northeurope  = "neu"
    swedencentral = "swc"
  }

  location_short = try(
    local.location_short_map[var.location],
    var.location
  )

  #
  # ---------------------------------------------------------
  # Shared naming suffix
  # ---------------------------------------------------------
  #

  resource_suffix = join("-", [
    local.environment,
    local.location_short,
    local.project_code,
    local.workload_id
  ])

  #
  # ---------------------------------------------------------
  # Common resource names
  # ---------------------------------------------------------
  #

  resource_group_name = "rg-${local.resource_suffix}"

  #
  # ---------------------------------------------------------
  # Common tags
  # ---------------------------------------------------------
  #

  common_tags = {
    environment = local.environment
    workload    = local.workload_key
    project     = local.project_code
    managed_by  = "terraform"
  }

  #
  # ---------------------------------------------------------
  # Environment behaviors
  # ---------------------------------------------------------
  #

  resource_group_lock_enabled = local.env_code == "P"
}

#
# ---------------------------------------------------------
# Validation
# ---------------------------------------------------------
#

check "config_file_exists" {
  assert {
    condition     = fileexists(var.config_path)
    error_message = "Config file does not exist: ${var.config_path}"
  }
}

check "workload_exists_in_config" {
  assert {
    condition = contains(
      keys(try(local.config.environments, {})),
      var.target_workload
    )

    error_message = "Workload '${var.target_workload}' was not found in config.yaml"
  }
}

check "valid_workload_format" {
  assert {
    condition = can(
      regex(
        "^([DTSP])([0-9]{4})-([A-Za-z0-9]+)$",
        var.target_workload
      )
    )

    error_message = "Invalid workload format. Expected format: <ENV><4 digits>-<PROJECT_CODE>"
  }
}

check "supported_environment_code" {
  assert {
    condition = contains(
      keys(local.env_map),
      local.env_code
    )

    error_message = "Unsupported environment code '${local.env_code}'"
  }
}