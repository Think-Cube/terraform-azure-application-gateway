module "application_gateway" {
  source = "github.com/Think-Cube/terraform-azure-application-gateway?ref=v1.0.0"

  name                = "agw-prod-example"
  resource_group_name = "rg-example"
  location            = "West Europe"
  public_ip_name      = "pip-agw-prod-example"
  vnet_name           = "vnet-example"
  vnet_rg_name        = "rg-example"
  subnet_name         = "snet-agw"

  sku_name     = "WAF_v2"
  sku_tier     = "WAF_v2"
  http2_enabled = true
  zones        = ["1", "2", "3"]

  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 10
  }

  identity = {
    type         = "UserAssigned"
    identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-agw"]
  }

  frontend_ip_configurations = [
    {
      name                 = "public-frontend-ip"
      public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Network/publicIPAddresses/pip-agw-prod-example"
    }
  ]

  ssl_certificates = [
    {
      name                = "app-cert"
      key_vault_secret_id = "https://kv-example.vault.azure.net/secrets/app-cert"
    }
  ]

  backend_address_pools = [
    { name = "api-pool",      fqdns = ["api.example.com"] },
    { name = "frontend-pool", fqdns = ["app.example.com"] }
  ]

  backend_http_settings = [
    {
      name                                = "https-settings"
      cookie_based_affinity               = "Disabled"
      port                                = 443
      protocol                            = "Https"
      request_timeout                     = 60
      pick_host_name_from_backend_address = true
    }
  ]

  http_listeners = [
    {
      name                           = "https-listener"
      frontend_ip_configuration_name = "public-frontend-ip"
      frontend_port_name             = "https"
      protocol                       = "Https"
      ssl_certificate_name           = "app-cert"
    }
  ]

  probes = [
    {
      name                                      = "health-probe"
      protocol                                  = "Https"
      path                                      = "/health"
      interval                                  = 30
      timeout                                   = 30
      unhealthy_threshold                       = 3
      pick_host_name_from_backend_http_settings = true
    }
  ]

  request_routing_rules = [
    {
      name                       = "https-routing-rule"
      rule_type                  = "Basic"
      http_listener_name         = "https-listener"
      backend_address_pool_name  = "api-pool"
      backend_http_settings_name = "https-settings"
      priority                   = 100
    }
  ]

  waf_configuration = {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  ssl_policy = {
    policy_type          = "Predefined"
    policy_name          = "AppGwSslPolicy20220101"
    min_protocol_version = "TLSv1_2"
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}