data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "sql_admin_login" {
  name         = var.sql_admin_login_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = var.sql_admin_password_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

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

  #   express_vulnerability_assessment_enabled = false
  #   connection_policy                        = "Default"
}

resource "azurerm_mssql_database" "sql_database" {
  name         = "sqldb-${var.project_name}-${var.environment}"
  server_id    = azurerm_mssql_server.sql_server.id
  collation    = "Latin1_General_100_CI_AS_SC_UTF8"
  create_mode  = "Default"
  max_size_gb  = var.sql_database_max_size_gb
  sku_name     = var.sql_database_sku

  # For Encryption
  transparent_data_encryption_enabled = true
  enclave_type                        = "VBS"

  # zone_redundant       = false
  # geo_backup_enabled   = false
  # storage_account_type = "Local"
  # sample_name          = "AdventureWorksLT"

  zone_redundant       = true
  geo_backup_enabled   = true
  storage_account_type = "GeoZone"
  secondary_type       = "Geo"

  tags = var.tags

  #   prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }

  short_term_retention_policy {
    retention_days           = 35
    backup_interval_in_hours = 12
  }

  long_term_retention_policy {
    weekly_retention  = "P12W"
    monthly_retention = "P12M"
    yearly_retention  = "P5Y"
    week_of_year      = 1
  }

}