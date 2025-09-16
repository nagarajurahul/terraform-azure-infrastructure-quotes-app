# data "azurerm_client_config" "current" {}

# resource "azurerm_user_assigned_identity" "sql_mi" {
#   name                = "sql-mi-${var.project_name}-${var.environment}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
# }

resource "azurerm_mssql_server" "sql_server" {
  name                = "sqlserver-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.sql_server_version
  minimum_tls_version = "1.2"
  tags                = var.tags

  administrator_login          = data.azurerm_key_vault_secret.sql_admin_login.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_admin_password.value

  public_network_access_enabled        = false
  outbound_network_restriction_enabled = true

  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.sql_mi.id]
  # }

  # primary_user_assigned_identity_id = azurerm_user_assigned_identity.sql_mi.id

  # azuread_administrator {
  #   login_username              = var.sql_login_username
  #   object_id                   = var.sql_admin_group_object_id
  #   tenant_id                   = data.azurerm_client_config.current.tenant_id
  #   azuread_authentication_only = true
  # }

  #   express_vulnerability_assessment_enabled = false
  #   connection_policy                        = "Default"
}

# https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-single-databases?view=azuresql
# Mainly designed for provisioned database for high speed PII workloads

resource "azurerm_mssql_database" "sql_database" {
  name        = "sqldb-${var.project_name}-${var.environment}"
  server_id   = azurerm_mssql_server.sql_server.id
  collation   = "Latin1_General_100_CI_AS_SC_UTF8"
  create_mode = "Default"
  max_size_gb = var.sql_database_max_size_gb
  sku_name    = var.sql_database_sku
  tags        = var.tags


  # For Encryption
  transparent_data_encryption_enabled = true
  enclave_type                        = "VBS"

  # Comment below 4 lines for production

  zone_redundant       = false
  geo_backup_enabled   = true
  storage_account_type = "Local"
  # sample_name          = "AdventureWorksLT"

  # Uncomment below lines for production

  # zone_redundant       = true
  # geo_backup_enabled   = true
  # storage_account_type = "GeoZone"
  # secondary_type       = "Geo"

  #   prevent the possibility of accidental data loss
  # lifecycle {
  #   prevent_destroy = true
  # }

  # short_term_retention_policy {
  #   retention_days           = 35
  #   backup_interval_in_hours = 12
  # }

  # long_term_retention_policy {
  #   weekly_retention  = "P12W"
  #   monthly_retention = "P12M"
  #   yearly_retention  = "P5Y"
  #   week_of_year      = 1
  # }

}

# Also enable monitoring and auditing for production here