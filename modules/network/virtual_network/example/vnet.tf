locals {
  vnet_config = try(local.workload_config.network.vnet, {})

  vnet_name = "vnet-${local.resource_suffix}"
}

module "vnet" {
  source = "../../../modules/network/virtual_network"

  name                = local.vnet_name
  location            = var.location
  resource_group_name = module.resource_group.name

  address_space = try(
    local.vnet_config.address_space,
    ["10.10.0.0/16"]
  )

  subnets = try(
    local.vnet_config.subnets,
    {}
  )

  tags = local.common_tags
}