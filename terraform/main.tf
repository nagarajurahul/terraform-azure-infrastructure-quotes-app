# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
# https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

resource "time_sleep" "wait_rg" {
  create_duration = "15s"

  depends_on = [azurerm_resource_group.rg]
}

module "vnet" {
  source     = "./modules/vnet"
  depends_on = [time_sleep.wait_rg]

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_cidr   = var.vnet_cidr
  dns_servers = var.dns_servers
}

module "subnets" {
  source     = "./modules/subnets"
  depends_on = [module.vnet]

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_name    = module.vnet.vnet_name
  subnet_cidrs = var.subnet_cidrs

  sku                     = var.sku
  public_ip_prefix_length = var.public_ip_prefix_length
  public_ip_prefix_zones  = var.public_ip_prefix_zones

}

module "sql" {
  source     = "./modules/sql"
  depends_on = [module.subnets]

  resource_group_name = var.resource_group_name
  location            = var.location
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

  vnet_id                    = module.vnet.vnet_id
  private_endpoint_subnet_id = module.subnets.subnet_ids["db"]

  # sql_login_username        = var.sql_login_username
  # sql_admin_group_object_id = var.sql_admin_group_object_id
}

module "acr" {
  source     = "./modules/acr"
  depends_on = [module.subnets]

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_id      = module.vnet.vnet_id
  pe_subnet_id = module.subnets.subnet_ids["pe"]
}


module "app_service" {
  source     = "./modules/app-service"
  depends_on = [module.subnets, module.acr, module.sql]


  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_id   = module.vnet.vnet_id
  subnet_id = module.subnets.subnet_ids["app"]

  web_app_sku_name           = var.web_app_sku_name
  node_version               = var.node_version
  private_endpoint_subnet_id = module.subnets.subnet_ids["pe"]

  acr_login_server  = module.acr.acr_login_server
  acr_id            = module.acr.acr_id
  docker_image_name = var.docker_image_name
  docker_image_tag  = var.docker_image_tag
  db_name           = module.sql.sql_database_name
  db_host           = module.sql.sql_server_fqdn

  key_vault_name                = var.key_vault_name
  key_vault_resource_group_name = var.key_vault_resource_group_name
  db_user_login_secret_name     = var.db_user_login_secret_name
  db_user_password_secret_name  = var.db_user_password_secret_name
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

  depends_on = [module.subnets, module.app_service, module.certificate]

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  project_name        = var.project_name
  environment         = var.environment

  vnet_name                     = module.vnet.vnet_name
  application_gateway_subnet_id = module.subnets.subnet_ids["web"]
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
  host_name                           = module.app_service.webapp_default_hostname
}
