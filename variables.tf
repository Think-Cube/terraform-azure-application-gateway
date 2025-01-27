variable "environment" {
  description = "The environment used for the backend container name key (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "A mapping of tags to assign to the resource for classification and management purposes."
  type        = map(any)
}

variable "region" {
  description = "The Azure region in which resources are deployed, typically used for geographic redundancy and availability."
  type        = string
  default     = "weu"
}

variable "resource_group_location" {
  description = "The location/region where the Application Gateway is created. Changing this forces a new resource to be created."
  default     = "West Europe"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Application Gateway will be created."
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

variable "app_gateway_name" {
  description = "The name of the Application Gateway. This will be used for reference and identification of the resource."
  type        = string
  default     = "ApplicationGateway1"
}

variable "app_gateway_sku" {
  description = "The SKU (Stock Keeping Unit) of the Application Gateway. This determines the performance and capabilities of the Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_tier" {
  description = "The tier of the Application Gateway SKU, affecting pricing and features. Defaults to 'Standard_v2'."
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_capacity" {
  description = "The capacity (number of instances) for the Application Gateway. This defines the scale and load capacity."
  type        = number
  default     = 1
}
