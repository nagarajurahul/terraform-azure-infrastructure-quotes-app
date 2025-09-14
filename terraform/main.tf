provider "azurerm" {
  features {}
}

# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant

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

module "sql" {
  source = "./modules/sql"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  sql_server_version       = var.sql_server_version
  sql_database_max_size_gb = var.sql_database_max_size_gb
  sql_database_sku         = var.sql_database_sku

  key_vault_name                 = var.key_vault_name
  key_vault_resource_group_name  = var.key_vault_resource_group_name
  sql_admin_login_secret_name    = var.sql_admin_login_secret_name
  sql_admin_password_secret_name = var.sql_admin_password_secret_name

  vnet_id = module.network.vnet_id
  subnet_id = module.network.subnet_ids["db"]
}