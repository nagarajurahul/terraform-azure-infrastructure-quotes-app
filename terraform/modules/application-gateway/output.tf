output "appgateway_public_ip_id" {
  description = "The ID of the public IP assigned to the Application Gateway"
  value       = azurerm_public_ip.pip.id
}

output "appgateway_public_ip_address" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.pip.ip_address
}

output "appgateway_public_ip_fqdn" {
  description = "The FQDN associated with the Application Gateway Public IP"
  value       = azurerm_public_ip.pip.fqdn
}

output "application_gateway_id" {
  description = "The ID of the Application Gateway"
  value       = azurerm_application_gateway.application_gateway.id
}

output "application_gateway_name" {
  description = "The name of the Application Gateway"
  value       = azurerm_application_gateway.application_gateway.name
}

output "application_gateway_frontend_ip_configuration" {
  description = "The frontend IP configuration block of the Application Gateway"
  value       = azurerm_application_gateway.application_gateway.frontend_ip_configuration
}

output "application_gateway_backend_address_pool" {
  description = "The backend address pool configuration"
  value       = azurerm_application_gateway.application_gateway.backend_address_pool
}

output "application_gateway_http_settings" {
  description = "The backend HTTP settings block"
  value       = azurerm_application_gateway.application_gateway.backend_http_settings
}

output "application_gateway_http_listener" {
  description = "The HTTP listener configuration"
  value       = azurerm_application_gateway.application_gateway.http_listener
}

output "application_gateway_request_routing_rules" {
  description = "The request routing rules configuration"
  value       = azurerm_application_gateway.application_gateway.request_routing_rule
}
