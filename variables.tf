###########################
# Common vars
###########################
variable "environment" {
  description = "Specifies the environment key used for naming backend containers. Defaults to 'dev'."
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "A mapping of tags to assign to the resources for organizational and management purposes."
  type        = map(any)
}

variable "region" {
  description = "The geographical region where resources will be deployed. Defaults to 'weu' (West Europe)."
  type        = string
  default     = "weu"
}

###########################
# Resource groups vars
###########################
variable "resource_group_location" {
  description = "The location/region where the resource group will be created. Changing this will force a new resource to be created. Defaults to 'West Europe'."
  default     = "West Europe"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which resources will be created."
  type        = string
}
############################
# Application Gateway variables
############################
variable "subnet_name" {
  description = "The name of the subnet where the Application Gateway will be deployed."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network that the Application Gateway will use."
  type        = string
}

variable "vnet_rg_name" {
  description = "The name of the Resource Group where the Virtual Network exists."
  type        = string
}

variable "app_gateway_name" {
  description = "The name assigned to the Application Gateway. Defaults to 'ApplicationGateway1'."
  type        = string
  default     = "ApplicationGateway1"
}

variable "app_gateway_sku" {
  description = "The SKU name of the Application Gateway. This defines its pricing tier and capabilities. Defaults to 'Standard_v2'."
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_tier" {
  description = "The tier of the Application Gateway SKU, which determines its performance and features. Defaults to 'Standard_v2'."
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_capacity" {
  description = "The capacity (number of instances) of the Application Gateway. Defaults to 1."
  type        = number
  default     = 1
}
