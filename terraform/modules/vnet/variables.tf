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

variable "vnet_cidr" {
  type        = string
  description = "CIDR for the VNet"
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)"
}
