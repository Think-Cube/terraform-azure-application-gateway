# Terraform Module — Azure Application Gateway

Provisions an `azurerm_application_gateway` with configurable SKU, WAF, SSL, routing rules, probes, and autoscaling.

## Usage

```hcl
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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscale_configuration"></a> [autoscale\_configuration](#input\_autoscale\_configuration) | Optional autoscale configuration block. | <pre>object({<br>    min_capacity = number<br>    max_capacity = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | List of backend address pool blocks. | <pre>list(object({<br>    name         = string<br>    fqdns        = optional(list(string), [])<br>    ip_addresses = optional(list(string), [])<br>  }))</pre> | <pre>[<br>  {<br>    "name": "default-backend-pool"<br>  }<br>]</pre> | no |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | List of backend HTTP settings blocks. | <pre>list(object({<br>    name                                = string<br>    cookie_based_affinity               = string<br>    port                                = number<br>    protocol                            = string<br>    affinity_cookie_name                = optional(string, null)<br>    host_name                           = optional(string, null)<br>    pick_host_name_from_backend_address = optional(bool, false)<br>    probe_name                          = optional(string, null)<br>    request_timeout                     = optional(number, 30)<br>    path                                = optional(string, null)<br>    trusted_root_certificate_names      = optional(list(string), [])<br>    connection_draining = optional(object({<br>      enabled           = bool<br>      drain_timeout_sec = number<br>    }), null)<br>  }))</pre> | <pre>[<br>  {<br>    "cookie_based_affinity": "Disabled",<br>    "name": "default-http-settings",<br>    "port": 80,<br>    "protocol": "Http",<br>    "request_timeout": 30<br>  }<br>]</pre> | no |
| <a name="input_custom_error_configurations"></a> [custom\_error\_configurations](#input\_custom\_error\_configurations) | List of custom error configuration blocks. | <pre>list(object({<br>    status_code           = string<br>    custom_error_page_url = string<br>  }))</pre> | `[]` | no |
| <a name="input_fips_enabled"></a> [fips\_enabled](#input\_fips\_enabled) | Is FIPS enabled on the Application Gateway? | `bool` | `false` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | The ID of the Web Application Firewall Policy which should be used as an HTTP Listener. | `string` | `null` | no |
| <a name="input_frontend_ip_configurations"></a> [frontend\_ip\_configurations](#input\_frontend\_ip\_configurations) | List of frontend IP configuration blocks. | <pre>list(object({<br>    name                            = string<br>    subnet_id                       = optional(string, null)<br>    private_ip_address              = optional(string, null)<br>    private_ip_address_allocation   = optional(string, null)<br>    public_ip_address_id            = optional(string, null)<br>    private_link_configuration_name = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_frontend_ports"></a> [frontend\_ports](#input\_frontend\_ports) | List of frontend port blocks. | <pre>list(object({<br>    name = string<br>    port = number<br>  }))</pre> | <pre>[<br>  {<br>    "name": "http",<br>    "port": 80<br>  },<br>  {<br>    "name": "https",<br>    "port": 443<br>  }<br>]</pre> | no |
| <a name="input_gateway_ip_configurations"></a> [gateway\_ip\_configurations](#input\_gateway\_ip\_configurations) | List of gateway IP configuration blocks. | <pre>list(object({<br>    name      = string<br>    subnet_id = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_global"></a> [global](#input\_global) | Optional global configuration block. | <pre>object({<br>    request_buffering_enabled  = bool<br>    response_buffering_enabled = bool<br>  })</pre> | `null` | no |
| <a name="input_http2_enabled"></a> [http2\_enabled](#input\_http2\_enabled) | Is HTTP2 enabled on the application gateway resource? | `bool` | `false` | no |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | List of HTTP listener blocks. | <pre>list(object({<br>    name                           = string<br>    frontend_ip_configuration_name = string<br>    frontend_port_name             = string<br>    protocol                       = string<br>    host_name                      = optional(string, null)<br>    host_names                     = optional(list(string), [])<br>    require_sni                    = optional(bool, false)<br>    ssl_certificate_name           = optional(string, null)<br>    firewall_policy_id             = optional(string, null)<br>    ssl_profile_name               = optional(string, null)<br>    custom_error_configurations = optional(list(object({<br>      status_code           = string<br>      custom_error_page_url = string<br>    })), [])<br>  }))</pre> | <pre>[<br>  {<br>    "frontend_ip_configuration_name": "default-frontend-ip",<br>    "frontend_port_name": "http",<br>    "name": "default-http-listener",<br>    "protocol": "Http"<br>  }<br>]</pre> | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Optional identity block. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the Application Gateway is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Application Gateway. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_link_configurations"></a> [private\_link\_configurations](#input\_private\_link\_configurations) | List of private link configuration blocks. | <pre>list(object({<br>    name = string<br>    ip_configurations = list(object({<br>      name                          = string<br>      subnet_id                     = string<br>      private_ip_address_allocation = string<br>      primary                       = bool<br>      private_ip_address            = optional(string, null)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | List of probe blocks. | <pre>list(object({<br>    name                                      = string<br>    protocol                                  = string<br>    path                                      = string<br>    interval                                  = number<br>    timeout                                   = number<br>    unhealthy_threshold                       = number<br>    host                                      = optional(string, null)<br>    pick_host_name_from_backend_http_settings = optional(bool, false)<br>    port                                      = optional(number, null)<br>    minimum_servers                           = optional(number, 0)<br>    match = optional(object({<br>      body        = optional(string, null)<br>      status_code = optional(list(string), [])<br>    }), null)<br>  }))</pre> | `[]` | no |
| <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name) | The name of the public IP address for the Application Gateway. | `string` | `null` | no |
| <a name="input_redirect_configurations"></a> [redirect\_configurations](#input\_redirect\_configurations) | List of redirect configuration blocks. | <pre>list(object({<br>    name                 = string<br>    redirect_type        = string<br>    target_listener_name = optional(string, null)<br>    target_url           = optional(string, null)<br>    include_path         = optional(bool, false)<br>    include_query_string = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | List of request routing rule blocks. | <pre>list(object({<br>    name                        = string<br>    rule_type                   = string<br>    http_listener_name          = string<br>    priority                    = optional(number, null)<br>    backend_address_pool_name   = optional(string, null)<br>    backend_http_settings_name  = optional(string, null)<br>    redirect_configuration_name = optional(string, null)<br>    rewrite_rule_set_name       = optional(string, null)<br>    url_path_map_name           = optional(string, null)<br>  }))</pre> | <pre>[<br>  {<br>    "backend_address_pool_name": "default-backend-pool",<br>    "backend_http_settings_name": "default-http-settings",<br>    "http_listener_name": "default-http-listener",<br>    "name": "default-routing-rule",<br>    "priority": 100,<br>    "rule_type": "Basic"<br>  }<br>]</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the Application Gateway will be created. | `string` | n/a | yes |
| <a name="input_rewrite_rule_sets"></a> [rewrite\_rule\_sets](#input\_rewrite\_rule\_sets) | List of rewrite rule set blocks. | <pre>list(object({<br>    name = string<br>    rewrite_rules = optional(list(object({<br>      name          = string<br>      rule_sequence = number<br>      conditions = optional(list(object({<br>        variable    = string<br>        pattern     = string<br>        ignore_case = optional(bool, false)<br>        negate      = optional(bool, false)<br>      })), [])<br>      request_header_configurations = optional(list(object({<br>        header_name  = string<br>        header_value = string<br>      })), [])<br>      response_header_configurations = optional(list(object({<br>        header_name  = string<br>        header_value = string<br>      })), [])<br>      url = optional(object({<br>        path         = optional(string, null)<br>        query_string = optional(string, null)<br>        reroute      = optional(bool, false)<br>      }), null)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_sku_capacity"></a> [sku\_capacity](#input\_sku\_capacity) | The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. Omit when autoscale\_configuration is set. | `number` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU to use for this Application Gateway. Accepted values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2. | `string` | `"Standard_v2"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The Tier of the SKU to use for this Application Gateway. Accepted values are Standard, Standard\_v2, WAF and WAF\_v2. | `string` | `"Standard_v2"` | no |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | List of SSL certificate blocks. | <pre>list(object({<br>    name                = string<br>    data                = optional(string, null)<br>    password            = optional(string, null)<br>    key_vault_secret_id = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Optional SSL policy block. | <pre>object({<br>    policy_name          = optional(string, null)<br>    policy_type          = optional(string, null)<br>    cipher_suites        = optional(list(string), [])<br>    min_protocol_version = optional(string, null)<br>    disabled_protocols   = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_ssl_profiles"></a> [ssl\_profiles](#input\_ssl\_profiles) | List of SSL profile blocks. | <pre>list(object({<br>    name                             = string<br>    trusted_client_certificate_names = optional(list(string), [])<br>    verify_client_cert_issuer_dn     = optional(bool, false)<br>    ssl_policy = optional(object({<br>      policy_name          = optional(string, null)<br>      policy_type          = optional(string, null)<br>      cipher_suites        = optional(list(string), [])<br>      min_protocol_version = optional(string, null)<br>      disabled_protocols   = optional(list(string), [])<br>    }), null)<br>  }))</pre> | `[]` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet where the Application Gateway will be deployed. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_trusted_client_certificates"></a> [trusted\_client\_certificates](#input\_trusted\_client\_certificates) | List of trusted client certificate blocks. | <pre>list(object({<br>    name = string<br>    data = string<br>  }))</pre> | `[]` | no |
| <a name="input_trusted_root_certificates"></a> [trusted\_root\_certificates](#input\_trusted\_root\_certificates) | List of trusted root certificate blocks. | <pre>list(object({<br>    name                = string<br>    data                = optional(string, null)<br>    key_vault_secret_id = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_url_path_maps"></a> [url\_path\_maps](#input\_url\_path\_maps) | List of URL path map blocks. | <pre>list(object({<br>    name                                = string<br>    default_backend_address_pool_name   = optional(string, null)<br>    default_backend_http_settings_name  = optional(string, null)<br>    default_redirect_configuration_name = optional(string, null)<br>    default_rewrite_rule_set_name       = optional(string, null)<br>    path_rules = list(object({<br>      name                        = string<br>      paths                       = list(string)<br>      backend_address_pool_name   = optional(string, null)<br>      backend_http_settings_name  = optional(string, null)<br>      redirect_configuration_name = optional(string, null)<br>      rewrite_rule_set_name       = optional(string, null)<br>      firewall_policy_id          = optional(string, null)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the Virtual Network where the Application Gateway will be deployed. | `string` | n/a | yes |
| <a name="input_vnet_rg_name"></a> [vnet\_rg\_name](#input\_vnet\_rg\_name) | The name of the Resource Group containing the Virtual Network where the Application Gateway will be deployed. | `string` | n/a | yes |
| <a name="input_waf_configuration"></a> [waf\_configuration](#input\_waf\_configuration) | Optional WAF configuration block. | <pre>object({<br>    enabled          = bool<br>    firewall_mode    = string<br>    rule_set_type    = optional(string, "OWASP")<br>    rule_set_version = string<br>    disabled_rule_groups = optional(list(object({<br>      rule_group_name = string<br>      rules           = optional(list(number), [])<br>    })), [])<br>    exclusions = optional(list(object({<br>      match_variable          = string<br>      selector_match_operator = optional(string, null)<br>      selector                = optional(string, null)<br>    })), [])<br>    file_upload_limit_mb     = optional(number, 100)<br>    request_body_check       = optional(bool, true)<br>    max_request_body_size_kb = optional(number, 128)<br>  })</pre> | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A collection of availability zones to spread the Application Gateway over. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_address_pool_ids"></a> [backend\_address\_pool\_ids](#output\_backend\_address\_pool\_ids) | Map of backend address pool names to their IDs. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Application Gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Application Gateway. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The public IP address of the Application Gateway. |
<!-- END_TF_DOCS -->