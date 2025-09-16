variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the VNet."
}

variable "location" {
  type        = string
  description = "The Azure location where resources will be created."
}

variable "tags" {
  type        = map(string)
  description = "A map of custom tags to assign to resources."
  default     = {}
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for the Virtual Network (e.g., 10.0.0.0/16)."
}

variable "dns_servers" {
  type        = list(string)
  description = "Optional list of DNS servers to use for the VNet."
  default     = []
}

variable "project_name" {
  type        = string
  description = "Project name (used for resource naming)."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)."
}