# https://learn.microsoft.com/en-us/azure/private-link/create-private-endpoint-terraform?tabs=azure-cli
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint

resource "azurerm_container_registry" "acr" {
  name                = "${var.project_name}acr${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  sku                 = var.acr_sku

  # Disable for production
  public_network_access_enabled = true
  admin_enabled       = false
  
  # Enable for production
  # zone_redundancy_enabled = true
}
