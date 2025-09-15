terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
  }
}

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

  vnet_id   = module.network.vnet_id
  subnet_id = module.network.subnet_ids["db"]
}

module "app_service" {
  source = "./modules/app-service"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_id   = module.network.vnet_id
  subnet_id = module.network.subnet_ids["app"]

  web_app_sku_name = var.web_app_sku_name
  node_version     = var.node_version
  private_endpoint_subnet_id = module.network.subnet_ids["db"]

}

module "certificate" {
  source = "./modules/certificate"

  custom_domain_name                        = var.custom_domain_name
  org_name                                  = var.org_name
  certificate_key_vault_name                = var.certificate_key_vault_name
  certificate_key_vault_resource_group_name = var.certificate_key_vault_resource_group_name
  project_name                              = var.project_name
  tags                                      = var.tags
}

module "application_gateway" {
  source = "./modules/application-gateway"

  depends_on = [module.network, module.certificate]

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_name                     = var.vnet_name
  application_gateway_subnet_id = module.network.subnet_ids["web"]
  backend_private_dns_address   = module.app_service.webapp_private_fqdn

  application_gateway_sku_name     = var.application_gateway_sku_name
  application_gateway_sku_tier     = var.application_gateway_sku_tier
  application_gateway_min_capacity = var.application_gateway_min_capacity
  application_gateway_max_capacity = var.application_gateway_max_capacity

  certificate_key_vault_name                = var.certificate_key_vault_name
  certificate_key_vault_resource_group_name = var.certificate_key_vault_resource_group_name
  identity_resource_group_name              = var.identity_resource_group_name

  key_vault_ssl_certificate_secret_id = module.certificate.key_vault_ssl_certificate_secret_id
  custom_domain_name                  = var.custom_domain_name
}
