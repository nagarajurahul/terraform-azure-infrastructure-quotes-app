terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }

  required_version = "~> 1.13.3"
}
