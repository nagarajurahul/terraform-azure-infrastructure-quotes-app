resource "azurerm_subnet" "mgmt" {
  name                 = "mgmt-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidrs["mgmt"]]
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidrs["web"]]
}

resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidrs["db"]]

  private_link_service_network_policies_enabled = false
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
# https://learn.microsoft.com/en-us/azure/app-service/environment/networking
# https://stackoverflow.com/questions/68735106/difference-between-azure-microsot-web-serverfams-vs-hostingenvironments

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidrs["app"]]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
