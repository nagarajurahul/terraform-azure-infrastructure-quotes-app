variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location where the resource group will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  type        = string
  description = "Name for the VNet"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR for the VNet"
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "subnet_cidrs" {
  type        = map(string)
  description = "CIDRs for web, app, db subnets"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "sku" {
  type        = string
  description = "SKU name"

  default = "Standard"
}

variable "public_ip_prefix_length" {
  type        = number
  description = "Public IP Prefix Length"
}

variable "public_ip_prefix_zones" {
  type        = list(string)
  description = "Public IP Prefix Zones"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)"
}

variable "web_app_sku_name" {
  type        = string
  description = "Web App SKU name"
}

variable "node_version" {
  type        = string
  description = "Node version for the Web App"
}