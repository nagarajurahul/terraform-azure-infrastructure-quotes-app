variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)"
}

variable "acr_sku" {
  type        = string
  description = "SKU for ACR"
  default     = "Premium"
}

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}

variable "pe_subnet_id" {
  type        = string
  description = "Subnet ID to deploy private endpoint"
}