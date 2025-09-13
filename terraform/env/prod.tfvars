location            = "East US"
tags                = { Environment = "Production", Project = "QuotesApp", Owner = "Rahul" }
project_name        = "quotes-app"
vnet_name           = "quotes-app-vnet-prod"
vnet_cidr           = "10.0.0.0/16"

subnet_cidrs = {
    web     = "10.0.1.0/24"   # 256 IPs
    app     = "10.0.2.0/24"   # 256 IPs
    db      = "10.0.3.0/24"   # 256 IPs
    pe      = "10.0.4.0/27"   # 32 IPs
    bastion = "10.0.10.0/27"  # 32 IPs
}

sku                     = "Standard"
public_ip_prefix_length = 31
public_ip_prefix_zones  = ["1", "2", "3"]
