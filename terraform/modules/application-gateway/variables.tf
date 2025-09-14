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
  description = "Private DNS Address of the App Service"
}