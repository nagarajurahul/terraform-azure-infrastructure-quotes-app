# output "service_plan_id" {
#   description = "The ID of the App Service Plan."
#   value       = module.app_service.service_plan_id
# }

# output "service_plan_name" {
#   description = "The name of the App Service Plan."
#   value       = module.app_service.service_plan_name
# }

# output "webapp_id" {
#   description = "The ID of the Linux Web App."
#   value       = module.app_service.webapp_id
# }

# output "webapp_name" {
#   description = "The name of the Linux Web App."
#   value       = module.app_service.webapp_name
# }

# output "webapp_default_hostname" {
#   description = "The default hostname of the Web App (e.g., webapp.azurewebsites.net)."
#   value       = module.app_service.webapp_default_hostname
# }

# output "webapp_identity_principal_id" {
#   description = "The Principal ID of the System Assigned Identity for the Web App."
#   value       = module.app_service.webapp_identity_principal_id
# }

# output "webapp_identity_tenant_id" {
#   description = "The Tenant ID of the System Assigned Identity for the Web App."
#   value       = module.app_service.webapp_identity_tenant_id
# }

# output "acr_login_server" {
#   value = module.acr.acr_login_server
# }

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "vnet_name" {
  value = module.vnet.vnet_name
}
