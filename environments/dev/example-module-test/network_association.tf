resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for subnet_name, subnet in try(local.vnet_config.subnets, {}) :
    subnet_name => subnet
    if try(subnet.nsg_key, null) != null
  }

  subnet_id = module.vnet.subnet_ids[each.key]

  network_security_group_id = module.nsg[
    each.value.nsg_key
  ].id
}