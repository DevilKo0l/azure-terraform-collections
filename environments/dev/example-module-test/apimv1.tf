locals {
  apim_config = try(local.workload_config.apim, {})

  apim_name = "apim-${local.resource_suffix}"

  apim_virtual_network_type = try(
    local.apim_config.virtual_network_type,
    "None"
  )

  apim_subnet_key = try(
    local.apim_config.subnet_key,
    null
  )

  apim_subnet_id = contains(
    ["internal", "external"],
    lower(local.apim_virtual_network_type)
  ) ? module.vnet.subnet_ids[local.apim_subnet_key] : null
}

module "apim" {
  source = "../../../modules/paas/api_management_v1"

  name                = local.apim_name
  location            = var.location
  resource_group_name = module.resource_group.name

  publisher_name  = try(local.apim_config.publisher_name, "Platform Team")
  publisher_email = try(local.apim_config.publisher_email, "platform@example.com")

  sku_name = try(local.apim_config.sku_name, "Developer_1")

  virtual_network_type = local.apim_virtual_network_type
  subnet_id            = local.apim_subnet_id

  public_network_access_enabled = try(
    local.apim_config.public_network_access_enabled,
    true
  )

  tags = local.common_tags
}