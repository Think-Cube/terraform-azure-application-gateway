resource "azurerm_public_ip" "main" {
  count               = var.public_ip_name != null ? 1 : 0
  name                = var.public_ip_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
