module "application_gateway" {
  source = "github.com/Think-Cube/terraform-azure-application-gateway?ref=v1.0.0"

  name                = "my-appgw"
  resource_group_name = "my-rg"
  location            = "West Europe"

  sku_name     = "WAF_v2"
  sku_tier     = "WAF_v2"
  sku_capacity = 2

  gateway_ip_configurations = [
    { name = "appgw-ip-config", subnet_id = "/subscriptions/00000000/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/appgw-subnet" }
  ]

  frontend_ports = [
    { name = "http-port",  port = 80  },
    { name = "https-port", port = 443 }
  ]

  frontend_ip_configurations = [
    { name = "appgw-frontend-ip", public_ip_address_id = "/subscriptions/00000000/resourceGroups/my-rg/providers/Microsoft.Network/publicIPAddresses/appgw-pip" }
  ]

  backend_address_pools = [
    { name = "backend-pool", ip_addresses = ["10.0.1.4", "10.0.1.5"] }
  ]

  backend_http_settings = [
    { name = "http-settings", cookie_based_affinity = "Disabled", port = 80, protocol = "Http", request_timeout = 30 }
  ]

  http_listeners = [
    { name = "http-listener", frontend_ip_configuration_name = "appgw-frontend-ip", frontend_port_name = "http-port", protocol = "Http" }
  ]

  request_routing_rules = [
    { name = "routing-rule", rule_type = "Basic", http_listener_name = "http-listener", backend_address_pool_name = "backend-pool", backend_http_settings_name = "http-settings", priority = 100 }
  ]

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}