resource "azurerm_windows_web_app" "this" {
  count = local.create_windows ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  https_only = var.https_only

  tags = local.tags

  identity {
    type         = local.identity_type
    identity_ids = var.user_assigned_identity_ids
  }

  site_config {
    always_on = var.always_on

    ftps_state = var.ftps_state

    minimum_tls_version = var.minimum_tls_version
  }

  app_settings = var.app_settings
}

resource "azurerm_linux_web_app" "this" {
  count = local.create_linux ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  https_only = var.https_only

  tags = local.tags

  identity {
    type         = local.identity_type
    identity_ids = var.user_assigned_identity_ids
  }

  site_config {
    always_on = var.always_on

    ftps_state = var.ftps_state

    minimum_tls_version = var.minimum_tls_version

    dynamic "application_stack" {
      for_each = var.deploy_type == "container" ? [1] : []

      content {
        docker_image_name   = var.container_image_name
        docker_registry_url = var.container_registry_url
      }
    }
  }

  app_settings = merge(
    var.app_settings,

    var.deploy_type == "container" ? {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    } : {}
  )
}