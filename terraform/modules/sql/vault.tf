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
