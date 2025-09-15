output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "The name of the ACR"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "The login server of the ACR"
}

output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "The ID of the ACR"
}

output "acr_private_endpoint_ip" {
  value       = azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address
  description = "The private IP of the ACR Private Endpoint"
}

output "acr_private_dns_zone" {
  value       = azurerm_private_dns_zone.acr_dns.name
  description = "The private DNS zone used for ACR"
}