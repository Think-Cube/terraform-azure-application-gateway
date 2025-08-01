## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.38.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.38.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/4.38.1/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/4.38.1/docs/resources/public_ip) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.38.1/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.38.1/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.38.1/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_gateway_capacity"></a> [app\_gateway\_capacity](#input\_app\_gateway\_capacity) | The capacity (number of instances) for the Application Gateway. This defines the scale and load capacity. | `number` | `1` | no |
| <a name="input_app_gateway_name"></a> [app\_gateway\_name](#input\_app\_gateway\_name) | The name of the Application Gateway. This will be used for reference and identification of the resource. | `string` | `"ApplicationGateway1"` | no |
| <a name="input_app_gateway_sku"></a> [app\_gateway\_sku](#input\_app\_gateway\_sku) | The SKU (Stock Keeping Unit) of the Application Gateway. This determines the performance and capabilities of the Application Gateway. | `string` | `"Standard_v2"` | no |
| <a name="input_app_gateway_tier"></a> [app\_gateway\_tier](#input\_app\_gateway\_tier) | The tier of the Application Gateway SKU, affecting pricing and features. Defaults to 'Standard\_v2'. | `string` | `"Standard_v2"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | A mapping of tags to assign to the resource for classification and management purposes. | `map(any)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment used for the backend container name key (e.g., dev, prod). | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure region in which resources are deployed, typically used for geographic redundancy and availability. | `string` | `"weu"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | The location/region where the Application Gateway is created. Changing this forces a new resource to be created. | `string` | `"West Europe"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the Application Gateway will be created. | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet where the Application Gateway will be deployed. | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the Virtual Network where the Application Gateway will be deployed. | `string` | n/a | yes |
| <a name="input_vnet_rg_name"></a> [vnet\_rg\_name](#input\_vnet\_rg\_name) | The name of the Resource Group containing the Virtual Network where the Application Gateway will be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Application Gateway resource. This unique identifier is used to reference the Application Gateway within Azure. |
