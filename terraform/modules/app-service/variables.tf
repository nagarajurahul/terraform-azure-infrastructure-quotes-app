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

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the App Service"
}

variable "web_app_sku_name" {
  type        = string
  description = "Web App SKU name"
}

variable "node_version" {
  type        = string
  description = "Node version for the Web App"
}