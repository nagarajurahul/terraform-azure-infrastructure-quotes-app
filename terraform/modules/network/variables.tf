variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure location where the resource group will be created"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign"
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
}

variable "public_ip_prefix_length" {
  type        = number
  description = "Public IP Prefix Length"
}

variable "public_ip_prefix_zones" {
  type        = list(string)
  description = "Public IP Prefix Zones"
}