# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
# https://learn.microsoft.com/en-us/azure/app-service/environment/networking
# https://stackoverflow.com/questions/68735106/difference-between-azure-microsot-web-serverfams-vs-hostingenvironments

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidrs["app"]]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway
# https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview#availability-zones

resource "azurerm_public_ip_prefix" "nat" {
  name                = "${var.project_name}-pipprefix"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku                 = var.sku
  zones               = var.public_ip_prefix_zones
  prefix_length       = var.public_ip_prefix_length
}

resource "azurerm_nat_gateway" "nat" {
  name                = "${var.project_name}-nat"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku_name            = var.sku
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat" {
  nat_gateway_id      = azurerm_nat_gateway.nat.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "app_nat" {
  subnet_id      = azurerm_subnet.app.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
