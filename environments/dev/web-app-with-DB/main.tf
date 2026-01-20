resource "azurerm_resource_group" "rg" {
  name     = "my-resources-12345"
  location = "${var.location}"
  
}

module "app_service_plan" {
  source = "../../../modules/paas/appservice/serverfarm"
  //version = "2025.18.1"

  for_each = local.app_config["environments"][var.environment]["web"]["farm"]  

  resource_group_name = azurerm_resource_group.rg.name  
  location = azurerm_resource_group.rg.location 
  //diagnostics_config = var.app_config
  asset_tag = var.environment
  suffix = each.key
}
# module "web" {
#   source = "../../../modules/paas/windows-app-service"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   service_plan_id     = azurerm_service_plan.example.id  
# }

# resource "azurerm_service_plan" "example" {
#   name                = "example"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
#   sku_name            = "P1v2"
#   os_type             = "Windows"
# }

# resource "azurerm_windows_web_app" "example" {
#   name                = "myweb-12132"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_service_plan.example.location
#   service_plan_id     = azurerm_service_plan.example.id

#   site_config {
#     public_network_access_enabled = true
#     scm_use_main_ip_restriction = true    
#   }
# }


# data "azurerm_resource_group" "rg" {
#   name     = "ansumantest"
# }

# Virtual Network
# resource "azurerm_virtual_network" "vnet" {
#   name                = "ansumanapp-vnet"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   address_space       = ["10.4.0.0/16"]
# }

# # Subnets for App Service instances
# resource "azurerm_subnet" "appserv" {
#   name                 = "frontend-app"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.4.1.0/24"]
#   //enforce_private_link_endpoint_network_policies = true
# }

 
# # App Service Plan
# resource "azurerm_app_service_plan" "frontend" {
#   name                = "ansuman-frontend-asp"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   kind                = "Linux"
#   reserved            = true

#   sku {
#     tier = "Premium"
#     size = "P1V2"
#   }
# }

# resource "azurerm_service_plan" "frontend" {
#   name                = "example"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku_name            = "P1v2"
#   os_type             = "Windows"
# }

# resource "azurerm_windows_web_app" "frontend" {
#   name                = "myweb-12132"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   service_plan_id     = azurerm_service_plan.frontend.id
#   public_network_access_enabled = false

#   site_config {
    
#     scm_use_main_ip_restriction = true    
#   }
# }

# App Service
# resource "azurerm_app_service" "frontend" {
#   name                = "ansuman-frontend-app-123224"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   app_service_plan_id = azurerm_app_service_plan.frontend.id
  
#   site_config {    
#     scm_use_main_ip_restriction = true    
#   }

# }
#private endpoint

# resource "azurerm_private_endpoint" "example" {
#   name                = "${azurerm_windows_web_app.frontend.name}-endpoint"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.appserv.id
  

#   private_service_connection {
#     name                           = "${azurerm_windows_web_app.frontend.name}-privateconnection"
#     private_connection_resource_id = azurerm_windows_web_app.frontend.id
#     subresource_names = ["sites"]
#     is_manual_connection = false
#   }
# }

# # private DNS
# resource "azurerm_private_dns_zone" "example" {
#   name                = "privatelink.azurewebsites.net"
#   resource_group_name = azurerm_resource_group.rg.name
# }

# #private DNS Link
# resource "azurerm_private_dns_zone_virtual_network_link" "example" {
#   name                  = "${azurerm_windows_web_app.frontend.name}-dnslink"
#   resource_group_name   = azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.example.name
#   virtual_network_id    = azurerm_virtual_network.vnet.id
#   registration_enabled = false
# }