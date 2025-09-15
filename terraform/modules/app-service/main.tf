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
    application_stack {
      docker_image_name   = "{var.docker_image_name}}:{var.docker_image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    # Ensure App Service uses managed identity to pull from ACR
    container_registry_use_managed_identity = true

    # Ensure App Service pulls over VNet since we using private endpoints
    vnet_route_all_enabled = true

    always_on                         = true
    http2_enabled                     = true
    minimum_tls_version               = "1.2"
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 2
  }

  app_settings = {
    WEBSITES_PORT = "8080"
    NODE_ENV      = "production"
    DB_HOST       = var.db_host
    DB_NAME       = var.db_name
    DB_PORT = var.db_port
    # Only for dev/testing
    DB_USER = data.azurerm_key_vault_secret.db_user_login.value
    DB_PASS = data.azurerm_key_vault_secret.db_user_password.value
  }

  vnet_image_pull_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
}
