# Create the Linux App Service Plan
resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Windows"
  sku_name            = var.sku_name  # e.g. P1v3, S1, B1
  
}

resource "azurerm_windows_web_app" "example" {
  name                = "example"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    always_on = true
    ftps_state = true
    scm_use_main_ip_restriction = true
  }
}
# Create the web app, pass in the App Service Plan ID
