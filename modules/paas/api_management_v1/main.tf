resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name = var.sku_name

  virtual_network_type = local.virtual_network_type

  dynamic "virtual_network_configuration" {
    for_each = local.use_vnet_injection ? [1] : []

    content {
      subnet_id = var.subnet_id
    }
  }

  public_network_access_enabled = var.public_network_access_enabled
  client_certificate_enabled    = var.client_certificate_enabled
  min_api_version               = var.min_api_version

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "SystemAssigned" ? null : var.identity_ids
  }

  tags = local.tags
}