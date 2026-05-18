locals {
  virtual_network_type = title(lower(var.virtual_network_type))

  use_vnet_injection = contains(
    ["Internal", "External"],
    local.virtual_network_type
  )

  tags = merge(
    var.tags,
    {
      service   = "api_management"
      component = "apim"
      version   = "v1"
    }
  )
}