# output "vnet_id" {
#   value       = azurerm_virtual_network.vnet.id
#   description = "The ID of the Virtual Network"
# }

# output "vnet_name" {
#   value       = azurerm_virtual_network.vnet.name
#   description = "The name of the Virtual Network"
# }

output "vnet_id" {
  value       = data.azurerm_virtual_network.vnet_data.id
  description = "The ID of the Virtual Network"
}

output "vnet_name" {
  value       = local.local_vnet_name
  description = "The name of the Virtual Network"
}
