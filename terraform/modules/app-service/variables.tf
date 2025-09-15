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

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the App Service"
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

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Private Endpoint Subnet ID"
}

variable "acr_login_server" {
  type        = string
  description = "ACR Login Server"
}

variable "acr_id" {
  type        = string
  description = "ACR ID"
}

variable "docker_image_name" {
  type        = string
  description = "Docker Image Name"
}

variable "docker_image_tag" {
  type        = string
  description = "Docker Image Tag"
}

variable "db_host" {
  type = string
  description = "DB Host"
}

variable "db_name" {
  type = string
  description = "DB Name"
}

variable "db_port" {
  type = string
  description = "DB Port"
  default = "1433"
}

variable "key_vault_name" {
  description = "Name of the Key Vault where DB credentials are stored"
  type        = string

  sensitive = true
}

variable "key_vault_resource_group_name" {
  description = "The name of the resource group where Key Vault is present"
  type        = string

  sensitive = true
}

variable "db_user_login_secret_name" {
  description = "Key Vault secret name for DB login"
  type        = string
}

variable "db_user_password_secret_name" {
  description = "Key Vault secret name for DB password"
  type        = string
}