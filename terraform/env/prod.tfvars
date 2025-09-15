location            = "Central US"
tags                = { Environment = "Production", Project = "QuotesApp", Owner = "Rahul" }
project_name        = "quotesapp"
environment = "prod"

vnet_name           = "vnet-quotesapp-prod"
vnet_cidr           = "10.0.0.0/16"

subnet_cidrs = {
    web     = "10.0.1.0/24"   # 256 IPs
    app     = "10.0.2.0/24"   # 256 IPs
    db      = "10.0.3.0/24"   # 256 IPs
    pe      = "10.0.4.0/27"   # 32 IPs
    bastion = "10.0.10.0/27"  # 32 IPs
    mgmt    = "10.0.11.0/27"  # 32 IPs
}

sku                     = "Standard"
public_ip_prefix_length = 31
public_ip_prefix_zones  = ["1", "2", "3"]

sql_server_version       = "12.0"
sql_database_max_size_gb = 0.5
sql_database_sku         = "Basic"

sql_admin_login_secret_name    = "SQL-QUOTES-APP-PROD-ADMIN-LOGIN"
sql_admin_password_secret_name = "SQL-QUOTES-APP-PROD-ADMIN-PASSWORD"

web_app_sku_name = "B1"
node_version     = "22-lts"

application_gateway_sku_name     = "Basic"
application_gateway_sku_tier     = "Basic"
application_gateway_min_capacity = 1
application_gateway_max_capacity = 2

custom_domain_name                        = "app.quotesapp.com"
org_name                                  = "Our Org"

docker_image_name = "quotesapp"
docker_image_tag  = "latest"

db_user_login_secret_name =  "SQL-QUOTES-APP-PROD-DB-USER-LOGIN"
db_user_password_secret_name =  "SQL-QUOTES-APP-PROD-DB-USER-PASSWORD"