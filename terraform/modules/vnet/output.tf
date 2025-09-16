# output "vnet_id" {
#   value = azurerm_virtual_network.vnet.id
# }

# output "vnet_name" {
#   value = azurerm_virtual_network.vnet.name
# }

output "vnet_id" {
  value = data.azurerm_virtual_network.vnet_data.id
}

output "vnet_name" {
  value = local.local_vnet_name
}
