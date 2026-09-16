variable "name" {
  description = "The name of the Application Gateway. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Application Gateway will be created."
  type        = string
}

variable "location" {
  description = "The location/region where the Application Gateway is created. Changing this forces a new resource to be created."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet where the Application Gateway will be deployed."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network where the Application Gateway will be deployed."
  type        = string
}

variable "vnet_rg_name" {
  description = "The name of the Resource Group containing the Virtual Network where the Application Gateway will be deployed."
  type        = string
}

# SKU
variable "sku_name" {
  description = "The Name of the SKU to use for this Application Gateway. Accepted values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "The Tier of the SKU to use for this Application Gateway. Accepted values are Standard, Standard_v2, WAF and WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. Omit when autoscale_configuration is set."
  type        = number
  default     = null
}

# Gateway IP configurations
variable "gateway_ip_configurations" {
  description = "List of gateway IP configuration blocks."
  type = list(object({
    name      = string
    subnet_id = optional(string, null)
  }))
  default = []
}

# Frontend ports
variable "frontend_ports" {
  description = "List of frontend port blocks."
  type = list(object({
    name = string
    port = number
  }))
  default = [
    { name = "http", port = 80 },
    { name = "https", port = 443 }
  ]
}

# Frontend IP configurations
variable "frontend_ip_configurations" {
  description = "List of frontend IP configuration blocks."
  type = list(object({
    name                            = string
    subnet_id                       = optional(string, null)
    private_ip_address              = optional(string, null)
    private_ip_address_allocation   = optional(string, null)
    public_ip_address_id            = optional(string, null)
    private_link_configuration_name = optional(string, null)
  }))
  default = []
}

# Backend address pools
variable "backend_address_pools" {
  description = "List of backend address pool blocks."
  type = list(object({
    name         = string
    fqdns        = optional(list(string), [])
    ip_addresses = optional(list(string), [])
  }))
  default = [
    { name = "default-backend-pool" }
  ]
}

# Backend HTTP settings
variable "backend_http_settings" {
  description = "List of backend HTTP settings blocks."
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    port                                = number
    protocol                            = string
    affinity_cookie_name                = optional(string, null)
    host_name                           = optional(string, null)
    pick_host_name_from_backend_address = optional(bool, false)
    probe_name                          = optional(string, null)
    request_timeout                     = optional(number, 30)
    path                                = optional(string, null)
    trusted_root_certificate_names      = optional(list(string), [])
    connection_draining = optional(object({
      enabled           = bool
      drain_timeout_sec = number
    }), null)
  }))
  default = [
    {
      name                  = "default-http-settings"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 30
    }
  ]
}

# HTTP listeners
variable "http_listeners" {
  description = "List of HTTP listener blocks."
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_name                      = optional(string, null)
    host_names                     = optional(list(string), [])
    require_sni                    = optional(bool, false)
    ssl_certificate_name           = optional(string, null)
    firewall_policy_id             = optional(string, null)
    ssl_profile_name               = optional(string, null)
    custom_error_configurations = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })), [])
  }))
  default = [
    {
      name                           = "default-http-listener"
      frontend_ip_configuration_name = "default-frontend-ip"
      frontend_port_name             = "http"
      protocol                       = "Http"
    }
  ]
}

# Request routing rules
variable "request_routing_rules" {
  description = "List of request routing rule blocks."
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    priority                    = optional(number, null)
    backend_address_pool_name   = optional(string, null)
    backend_http_settings_name  = optional(string, null)
    redirect_configuration_name = optional(string, null)
    rewrite_rule_set_name       = optional(string, null)
    url_path_map_name           = optional(string, null)
  }))
  default = [
    {
      name                       = "default-routing-rule"
      rule_type                  = "Basic"
      http_listener_name         = "default-http-listener"
      backend_address_pool_name  = "default-backend-pool"
      backend_http_settings_name = "default-http-settings"
      priority                   = 100
    }
  ]
}

# Autoscale configuration
variable "autoscale_configuration" {
  description = "Optional autoscale configuration block."
  type = object({
    min_capacity = number
    max_capacity = optional(number, null)
  })
  default = null
}

# Probes
variable "probes" {
  description = "List of probe blocks."
  type = list(object({
    name                                      = string
    protocol                                  = string
    path                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    host                                      = optional(string, null)
    pick_host_name_from_backend_http_settings = optional(bool, false)
    port                                      = optional(number, null)
    minimum_servers                           = optional(number, 0)
    match = optional(object({
      body        = optional(string, null)
      status_code = optional(list(string), [])
    }), null)
  }))
  default = []
}

# SSL certificates
variable "ssl_certificates" {
  description = "List of SSL certificate blocks."
  type = list(object({
    name                = string
    data                = optional(string, null)
    password            = optional(string, null)
    key_vault_secret_id = optional(string, null)
  }))
  default = []
}

# Redirect configurations
variable "redirect_configurations" {
  description = "List of redirect configuration blocks."
  type = list(object({
    name                 = string
    redirect_type        = string
    target_listener_name = optional(string, null)
    target_url           = optional(string, null)
    include_path         = optional(bool, false)
    include_query_string = optional(bool, false)
  }))
  default = []
}

# Rewrite rule sets
variable "rewrite_rule_sets" {
  description = "List of rewrite rule set blocks."
  type = list(object({
    name = string
    rewrite_rules = optional(list(object({
      name          = string
      rule_sequence = number
      conditions = optional(list(object({
        variable    = string
        pattern     = string
        ignore_case = optional(bool, false)
        negate      = optional(bool, false)
      })), [])
      request_header_configurations = optional(list(object({
        header_name  = string
        header_value = string
      })), [])
      response_header_configurations = optional(list(object({
        header_name  = string
        header_value = string
      })), [])
      url = optional(object({
        path         = optional(string, null)
        query_string = optional(string, null)
        reroute      = optional(bool, false)
      }), null)
    })), [])
  }))
  default = []
}

# URL path maps
variable "url_path_maps" {
  description = "List of URL path map blocks."
  type = list(object({
    name                                = string
    default_backend_address_pool_name   = optional(string, null)
    default_backend_http_settings_name  = optional(string, null)
    default_redirect_configuration_name = optional(string, null)
    default_rewrite_rule_set_name       = optional(string, null)
    path_rules = list(object({
      name                        = string
      paths                       = list(string)
      backend_address_pool_name   = optional(string, null)
      backend_http_settings_name  = optional(string, null)
      redirect_configuration_name = optional(string, null)
      rewrite_rule_set_name       = optional(string, null)
      firewall_policy_id          = optional(string, null)
    }))
  }))
  default = []
}

# WAF configuration
variable "waf_configuration" {
  description = "Optional WAF configuration block."
  type = object({
    enabled          = bool
    firewall_mode    = string
    rule_set_type    = optional(string, "OWASP")
    rule_set_version = string
    disabled_rule_groups = optional(list(object({
      rule_group_name = string
      rules           = optional(list(number), [])
    })), [])
    exclusions = optional(list(object({
      match_variable          = string
      selector_match_operator = optional(string, null)
      selector                = optional(string, null)
    })), [])
    file_upload_limit_mb     = optional(number, 100)
    request_body_check       = optional(bool, true)
    max_request_body_size_kb = optional(number, 128)
  })
  default = null
}

# Firewall policy
variable "firewall_policy_id" {
  description = "The ID of the Web Application Firewall Policy which should be used as an HTTP Listener."
  type        = string
  default     = null
}

# HTTP2
variable "http2_enabled" {
  description = "Is HTTP2 enabled on the application gateway resource?"
  type        = bool
  default     = false
}

# FIPS
variable "fips_enabled" {
  description = "Is FIPS enabled on the Application Gateway?"
  type        = bool
  default     = false
}

# Zones
variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = []
}

# Identity
variable "identity" {
  description = "Optional identity block."
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null
}

# Global configuration
variable "global" {
  description = "Optional global configuration block."
  type = object({
    request_buffering_enabled  = bool
    response_buffering_enabled = bool
  })
  default = null
}

# SSL policy
variable "ssl_policy" {
  description = "Optional SSL policy block."
  type = object({
    policy_name          = optional(string, null)
    policy_type          = optional(string, null)
    cipher_suites        = optional(list(string), [])
    min_protocol_version = optional(string, null)
    disabled_protocols   = optional(list(string), [])
  })
  default = null
}

# SSL profiles
variable "ssl_profiles" {
  description = "List of SSL profile blocks."
  type = list(object({
    name                             = string
    trusted_client_certificate_names = optional(list(string), [])
    verify_client_cert_issuer_dn     = optional(bool, false)
    ssl_policy = optional(object({
      policy_name          = optional(string, null)
      policy_type          = optional(string, null)
      cipher_suites        = optional(list(string), [])
      min_protocol_version = optional(string, null)
      disabled_protocols   = optional(list(string), [])
    }), null)
  }))
  default = []
}

# Trusted root certificates
variable "trusted_root_certificates" {
  description = "List of trusted root certificate blocks."
  type = list(object({
    name                = string
    data                = optional(string, null)
    key_vault_secret_id = optional(string, null)
  }))
  default = []
}

# Trusted client certificates
variable "trusted_client_certificates" {
  description = "List of trusted client certificate blocks."
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

# Private link configurations
variable "private_link_configurations" {
  description = "List of private link configuration blocks."
  type = list(object({
    name = string
    ip_configurations = list(object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      primary                       = bool
      private_ip_address            = optional(string, null)
    }))
  }))
  default = []
}

# Custom error configurations (global)
variable "custom_error_configurations" {
  description = "List of custom error configuration blocks."
  type = list(object({
    status_code           = string
    custom_error_page_url = string
  }))
  default = []
}

# Public IP
variable "public_ip_name" {
  description = "The name of the public IP address for the Application Gateway."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
