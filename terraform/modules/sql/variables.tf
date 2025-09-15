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

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where Private Endpoint resides"
  type        = string
}

# variable "web_app_name" {
#   description = "Web App name"
#   type        = string
#   default     = "webapp-quotesapp-production"
# }

# variable "sql_login_username" {
#   type      = string
#   default   = "Login Username for SQL"
#   sensitive = true
# }

# variable "sql_admin_group_object_id" {
#   description = "Object ID of the pre-created SQL Admins AAD group"
#   type        = string
#   sensitive   = true
# }