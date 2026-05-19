module "resource_group" {
  source = "../../../modules/core/resource_group"

  name     = local.resource_group_name
  location = var.location

  lock_enabled = local.resource_group_lock_enabled

  tags = local.common_tags
}