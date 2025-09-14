provider "azurerm" {
  features {}
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  vnet_name    = var.vnet_name
  vnet_cidr    = var.vnet_cidr
  dns_servers  = var.dns_servers
  subnet_cidrs = var.subnet_cidrs

  project_name            = var.project_name
  sku                     = var.sku
  public_ip_prefix_length = var.public_ip_prefix_length
  public_ip_prefix_zones  = var.public_ip_prefix_zones

}

module "app_service" {
  source = "./modules/app-service"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment
  subnet_id           = module.network.subnet_ids["app"]
  web_app_sku_name    = var.web_app_sku_name
  node_version        = var.node_version

}
