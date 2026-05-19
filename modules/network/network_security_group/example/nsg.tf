locals {
  nsg_config = try(local.workload_config.network.nsg, {})
}

module "nsg" {
  source = "../../../modules/network/network_security_group"

  for_each = local.nsg_config

  name                = "nsg-${local.resource_suffix}-${each.key}"
  location            = var.location
  resource_group_name = module.resource_group.name

  security_rules = try(each.value.security_rules, {})

  tags = local.common_tags
}