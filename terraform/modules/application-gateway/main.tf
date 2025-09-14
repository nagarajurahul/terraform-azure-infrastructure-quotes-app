
resource "azurerm_public_ip" "pip" {
  name                = "pip-appgateway-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  listener_name                  = "${var.vnet_name}-httplstn"
  request_routing_rule_name      = "${var.vnet_name}-rqrt"
  redirect_configuration_name    = "${var.vnet_name}-rdrcfg"
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = "appgateway-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  tags         = var.tags
  enable_http2 = true

  gateway_ip_configuration {
    name      = "ip-configuration-appgateway-${var.project_name}"
    subnet_id = var.application_gateway_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [var.backend_private_dns_address]
  }


  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = "/path1/"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name = "cert-appgateway-${var.project_name}"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}