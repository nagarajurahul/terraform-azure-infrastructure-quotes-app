output "subnet_ids" {
  description = "Map of subnet IDs for the deployed subnets (web, app, db, and mgmt)."

  value = {
    web  = azurerm_subnet.web.id
    app  = azurerm_subnet.app.id
    db   = azurerm_subnet.db.id
    mgmt = azurerm_subnet.mgmt.id
  }
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway associated with the App subnet."
  value = azurerm_nat_gateway.nat.id
}
