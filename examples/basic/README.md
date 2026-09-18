# Example: Basic

Minimal working example for `terraform-azure-application-gateway`.

```hcl
module "application_gateway" {
  source = "github.com/Think-Cube/terraform-azure-application-gateway?ref=v1.0.0"

  name                = "agw-dev-example"
  resource_group_name = "rg-example"
  location            = "West Europe"
  public_ip_name      = "pip-agw-dev-example"
  vnet_name           = "vnet-example"
  vnet_rg_name        = "rg-example"
  subnet_name         = "snet-agw"

  sku_name     = "Standard_v2"
  sku_tier     = "Standard_v2"

  autoscale_configuration = {
    min_capacity = 1
    max_capacity = 3
  }

  frontend_ip_configurations = [
    {
      name                 = "default-frontend-ip"
      public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Network/publicIPAddresses/pip-agw-dev-example"
    }
  ]

  backend_address_pools = [
    { name = "backend-pool", ip_addresses = ["10.0.1.10"] }
  ]

  backend_http_settings = [
    {
      name                  = "http-settings"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 30
    }
  ]

  http_listeners = [
    {
      name                           = "http-listener"
      frontend_ip_configuration_name = "default-frontend-ip"
      frontend_port_name             = "http"
      protocol                       = "Http"
    }
  ]

  request_routing_rules = [
    {
      name                       = "routing-rule"
      rule_type                  = "Basic"
      http_listener_name         = "http-listener"
      backend_address_pool_name  = "backend-pool"
      backend_http_settings_name = "http-settings"
      priority                   = 100
    }
  ]

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}```` 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application_gateway"></a> [application\_gateway](#module\_application\_gateway) | github.com/Think-Cube/terraform-azure-application-gateway | v1.0.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->