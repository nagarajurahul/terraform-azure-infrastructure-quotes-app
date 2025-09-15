output "service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.service_plan.id
}

output "service_plan_name" {
  description = "The name of the App Service Plan."
  value       = azurerm_service_plan.service_plan.name
}

output "webapp_id" {
  description = "The ID of the Linux Web App."
  value       = azurerm_linux_web_app.webapp.id
}

output "webapp_name" {
  description = "The name of the Linux Web App."
  value       = azurerm_linux_web_app.webapp.name
}

output "webapp_default_hostname" {
  description = "The default hostname of the Web App (e.g., webapp.azurewebsites.net)."
  value       = azurerm_linux_web_app.webapp.default_hostname
}

output "webapp_identity_principal_id" {
  description = "The Principal ID of the System Assigned Identity for the Web App."
  value       = azurerm_linux_web_app.webapp.identity[0].principal_id
}

output "webapp_identity_tenant_id" {
  description = "The Tenant ID of the System Assigned Identity for the Web App."
  value       = azurerm_linux_web_app.webapp.identity[0].tenant_id
}

output "webapp_private_fqdn" {
  description = "The private DNS name of the App Service"
  value       = "${azurerm_linux_web_app.webapp.name}.privatelink.azurewebsites.net"
}