# https://learn.microsoft.com/en-us/azure/private-link/create-private-endpoint-terraform?tabs=azure-cli
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint

resource "azurerm_private_endpoint" "app_pe" {
  name                = "app-pe-${var.project_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "app-privateserviceconnection-${var.project_name}"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app-dns-zone-group-${var.project_name}"
    private_dns_zone_ids = [azurerm_private_dns_zone.appservice_dns.id]
  }
}
resource "azurerm_private_dns_zone" "appservice_dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "appservice_dns_link" {
  name                  = "app-dns-link-${var.project_name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.appservice_dns.name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}

