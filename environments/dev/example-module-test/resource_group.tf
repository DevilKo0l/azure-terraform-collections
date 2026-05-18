module "rg" {
  source = "../../../modules/core/resource_group"

  name     = locals.resource_group_name
  location = var.location

  lock_enabled = locals.resource_group_lock_enabled

  tags = locals.common_tags
}