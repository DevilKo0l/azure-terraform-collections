locals {
  os_type     = lower(var.os_type)
  deploy_type = lower(var.deploy_type)

  tags = merge(
    var.tags,
    {
      service   = "app_service"
      component = "web_app"
      role      = var.role
      os_type   = local.os_type
    }
  )

  identity_type = (
    var.enable_system_assigned_identity && length(var.user_assigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" :
    var.enable_system_assigned_identity ? "SystemAssigned" :
    length(var.user_assigned_identity_ids) > 0 ? "UserAssigned" :
    null
  )

  create_windows = local.os_type == "windows"
  create_linux   = local.os_type == "linux"
}