# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate

data "azurerm_key_vault" "key_vault" {
  name                = var.certificate_key_vault_name
  resource_group_name = var.certificate_key_vault_resource_group_name
}

resource "azurerm_key_vault_certificate" "ssl_cert" {
  name         = "cert-appgateway-${var.project_name}"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tags         = var.tags

  certificate_policy {
    issuer_parameters {
      # Only for dev, for production use CA
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }
      trigger {
        days_before_expiry = 30
      }
    }

    x509_certificate_properties {
      subject            = "CN=${var.custom_domain_name}, O=${var.org_name}"
      validity_in_months = 12
      key_usage          = ["digitalSignature", "keyEncipherment"]
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"] # Server Auth only
      subject_alternative_names { dns_names = [var.custom_domain_name] }
    }
  }
}
