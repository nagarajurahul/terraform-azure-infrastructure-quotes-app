output "key_vault_ssl_certificate_secret_id" {
  value = azurerm_key_vault_certificate.ssl_cert.versionless_secret_id
}