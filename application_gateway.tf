locals {
  backend_address_pool_name      = "${var.environment}-${var.app_gateway_name}-${var.region}-agw-beap"
  frontend_port_name             = "${var.environment}-${var.app_gateway_name}-${var.region}-agw-feport"
  frontend_ip_configuration_name = "${var.environment}-${var.app_gateway_name}-${var.region}-agw-feip"
  http_setting_name              = "${var.environment}-${var.app_gateway_name}-${var.region}-agw-be-htst"
  listener_name                  = "${var.environment}-${var.app_gateway_name}-${var.region}-agw-httplstn"
  request_routing_rule_name      = "${var.environment}-${var.app_gateway_name}-${var.region}-agw-rqrt"
}

resource "azurerm_application_gateway" "main" {
  name                = "${var.environment}-${var.app_gateway_name}-${var.region}-agw"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    name     = var.app_gateway_sku
    tier     = var.app_gateway_tier
    capacity = var.app_gateway_capacity
  }

  gateway_ip_configuration {
    name      = "${var.environment}qia${var.app_gateway_name}${var.region}qgwconfig"
    subnet_id = data.azurerm_subnet.subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  tags = var.default_tags

  depends_on = [azurerm_public_ip.main]
}
