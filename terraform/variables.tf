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

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, qa, prod)"
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

variable "sql_server_version" {
  description = "Version of the Azure SQL Server (e.g., 12.0)"
  type        = string
  default     = "12.0"
}

variable "sql_database_max_size_gb" {
  description = "Max size (GB) of the SQL Database"
  type        = number
  default     = 32
}

variable "sql_database_sku" {
  description = "SKU name for the SQL Database (e.g., GP_Gen5_4)"
  type        = string
  default     = "GP_Gen5_4"
}

variable "key_vault_name" {
  description = "Name of the Key Vault where SQL admin credentials are stored"
  type        = string

  sensitive = true
}

variable "key_vault_resource_group_name" {
  description = "The name of the resource group where Key Vault is present"
  type        = string

  sensitive = true
}

variable "sql_admin_login_secret_name" {
  description = "Key Vault secret name for SQL administrator login"
  type        = string
}

variable "sql_admin_password_secret_name" {
  description = "Key Vault secret name for SQL administrator password"
  type        = string
}

variable "web_app_sku_name" {
  type        = string
  description = "Web App SKU name"
  default     = "P5mv4"
}

variable "node_version" {
  type        = string
  description = "Node version for the Web App"
}
