resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  address_space       = [var.vnet_cidr]
  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

# locals {
#   local_vnet_name = "vnet-${var.project_name}-${var.environment}"
# }
# data "azurerm_virtual_network" "vnet_data" {
#   name                = local.local_vnet_name
#   resource_group_name = var.resource_group_name
# }