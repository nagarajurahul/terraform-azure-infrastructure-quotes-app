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

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

resource "time_sleep" "wait_nat" {
  create_duration = "15s"

  depends_on = [azurerm_nat_gateway.nat]
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat" {
  nat_gateway_id      = azurerm_nat_gateway.nat.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat.id

  depends_on = [time_sleep.wait_nat]
}

resource "azurerm_subnet_nat_gateway_association" "app_nat" {
  subnet_id      = azurerm_subnet.app.id
  nat_gateway_id = azurerm_nat_gateway.nat.id

  depends_on = [azurerm_subnet.app, time_sleep.wait_nat]
}
