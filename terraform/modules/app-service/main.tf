resource "azurerm_service_plan" "service_plan" {
  name                = "service-plan-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  os_type             = "Linux"
  sku_name            = var.web_app_sku_name

  # premium_plan_auto_scale_enabled = true
  # per_site_scaling_enabled        = true
  # zone_balancing_enabled          = true
  # worker_count= 6
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  service_plan_id           = azurerm_service_plan.service_plan.id
  virtual_network_subnet_id = var.subnet_id
  depends_on                = [azurerm_service_plan.service_plan]

  public_network_access_enabled = false

  https_only = true
  # virtual_network_backup_restore_enabled = true

  site_config {
    minimum_tls_version = "1.2"
    health_check_path   = "/health"
    application_stack {
      node_version = var.node_version
    }
    app_command_line = "npm start"
  }

  identity {
    type = "SystemAssigned"
  }
}
