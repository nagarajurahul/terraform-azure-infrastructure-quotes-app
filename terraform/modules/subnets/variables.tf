variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure location where resources will be created"
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to assign to all resources."
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

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "subnet_cidrs" {
  type        = map(string)
  description = "CIDRs for web, app, db subnets"
}

variable "sku" {
  type        = string
  description = "SKU name"
}

variable "public_ip_prefix_length" {
  type        = number
  description = "Public IP Prefix Length"
}

variable "public_ip_prefix_zones" {
  type        = list(string)
  description = "Public IP Prefix Zones"
}