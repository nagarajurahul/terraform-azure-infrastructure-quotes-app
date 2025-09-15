variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure location where resources will be deployed"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)"
}

variable "vnet_name" {
  type        = string
  description = "Name for the VNet"
}

variable "application_gateway_subnet_id" {
  type        = string
  description = "Subnet ID to place the Application Gateway"
}

variable "backend_private_dns_address" {
  type        = string
  description = "Private DNS Address of the Backend"
}

variable "application_gateway_sku_name" {
  type        = string
  description = "SKU name for the Application Gateway"

  default = "WAF_v2"
}

variable "application_gateway_sku_tier" {
  type        = string
  description = "SKU tier for the Application Gateway"

  default = "WAF_v2"
}

variable "application_gateway_min_capacity" {
  type        = number
  description = "Minimum capacity for the Application Gateway"

  default = 2
}

variable "application_gateway_max_capacity" {
  type        = number
  description = "Maximum capacity for the Application Gateway"

  default = 10
}

variable "certificate_key_vault_name" {
  type        = string
  description = "Name of the key vault where certificate resides"
}

variable "certificate_key_vault_resource_group_name" {
  type        = string
  description = "Name of the key vault - resource group where certificate resides"
}

variable "identity_resource_group_name" {
  type        = string
  description = "Name of the resource group where identity resides"
}

variable "key_vault_ssl_certificate_secret_id" {
  type        = string
  description = "Secret ID of the Key Vault where certificate resides"
}

variable "custom_domain_name" {
  type        = string
  description = "Domain name"
}
