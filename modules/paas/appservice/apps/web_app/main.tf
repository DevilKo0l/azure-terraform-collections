resource "azurerm_windows_web_app" "this" {
  count               = local.create_windows ? 1 : 0
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  https_only              = local.final_https_only
  client_affinity_enabled = local.final_client_affinity

  app_settings = local.final_app_settings
  tags         = local.merged_tags

  dynamic "identity" {
    for_each = local.identity_type == null ? [] : [1]
    content {
      type         = local.identity_type
      identity_ids = length(var.user_assigned_identity_ids) > 0 ? var.user_assigned_identity_ids : null
    }
  }

  site_config {
    always_on           = local.final_always_on
    ftps_state          = local.final_ftps_state
    minimum_tls_version = local.final_min_tls

    # CODE stack
    dynamic "application_stack" {
      for_each = (local.final_deploy_type == "code" && var.windows_application_stack != null) ? [1] : []
      content {
        current_stack  = try(var.windows_application_stack.current_stack, null)
        dotnet_version = try(var.windows_application_stack.dotnet_version, null)
        node_version   = try(var.windows_application_stack.node_version, null)
      }
    }

    # CONTAINER (Windows): requires compatible plan/provider support.
    dynamic "application_stack" {
      for_each = (local.final_deploy_type == "container" && local.final_container != null) ? [1] : []
      content {
        docker_image_name        = local.final_container.image_name
        docker_registry_url      = try(local.final_container.registry_url, null)
        docker_registry_username = try(local.final_container.username, null)
        docker_registry_password = try(local.final_container.password, null)
      }
    }
  }

  dynamic "connection_string" {
    for_each = local.final_connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
}

resource "azurerm_linux_web_app" "this" {
  count               = local.create_linux ? 1 : 0
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  https_only              = local.final_https_only
  client_affinity_enabled = local.final_client_affinity

  app_settings = local.final_app_settings
  tags         = local.merged_tags

  dynamic "identity" {
    for_each = local.identity_type == null ? [] : [1]
    content {
      type         = local.identity_type
      identity_ids = length(var.user_assigned_identity_ids) > 0 ? var.user_assigned_identity_ids : null
    }
  }

  site_config {
    always_on           = local.final_always_on
    ftps_state          = local.final_ftps_state
    minimum_tls_version = local.final_min_tls

    # CODE stack
    dynamic "application_stack" {
      for_each = (local.final_deploy_type == "code" && var.linux_application_stack != null) ? [1] : []
      content {
        dotnet_version = try(var.linux_application_stack.dotnet_version, null)
        node_version   = try(var.linux_application_stack.node_version, null)
        python_version = try(var.linux_application_stack.python_version, null)
        java_version   = try(var.linux_application_stack.java_version, null)
      }
    }

    # CONTAINER (Linux)
    dynamic "application_stack" {
      for_each = (local.final_deploy_type == "container" && local.final_container != null) ? [1] : []
      content {
        docker_image_name        = local.final_container.image_name
        docker_registry_url      = try(local.final_container.registry_url, null)
        docker_registry_username = try(local.final_container.username, null)
        docker_registry_password = try(local.final_container.password, null)
      }
    }

    # Linux: ACR pull using managed identity (if desired)
    #acr_use_managed_identity_credentials = try(local.final_container.use_acr_mi, false)
    #acr_user_managed_identity_client_id  = try(local.final_container.uami_client_id, null)
  }

  dynamic "connection_string" {
    for_each = local.final_connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
}
