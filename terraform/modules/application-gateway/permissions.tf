data "azurerm_key_vault" "key_vault" {
  name                = var.certificate_key_vault_name
  resource_group_name = var.certificate_key_vault_resource_group_name
}


resource "azurerm_user_assigned_identity" "appgw_identity" {
  name                = "appgw_identity_${var.project_name}"
  location            = var.location
  resource_group_name = var.identity_resource_group_name
}

resource "azurerm_role_assignment" "appgw_kv_secret_access" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.appgw_identity.principal_id
}
