output "subnet_ids" {
  value = {
    web = azurerm_subnet.web.id
    app = azurerm_subnet.app.id
    db  = azurerm_subnet.db.id
  }
}

output "nat_gateway_id" {
  value = azurerm_nat_gateway.nat.id
}
