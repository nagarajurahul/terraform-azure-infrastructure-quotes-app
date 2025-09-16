variable "custom_domain_name" {
  type        = string
  description = "Domain name"
}

variable "org_name" {
  type        = string
  description = "Organisation name"
}

variable "certificate_key_vault_name" {
  type        = string
  description = "Name of the key vault where certificate needs to reside"
}

variable "certificate_key_vault_resource_group_name" {
  type        = string
  description = "Name of the key vault - resource group where certificate needs to reside"
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
