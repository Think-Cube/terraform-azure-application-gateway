resource "azurerm_public_ip" "main" {
  name                = "${var.environment}-${var.app_gateway_name}-${var.region}-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.default_tags
}


