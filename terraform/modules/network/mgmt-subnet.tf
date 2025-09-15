resource "azurerm_subnet" "mgmt" {
  name                 = "mgmt-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidrs["mgmt"]]
}

resource "azurerm_network_interface" "mgmt_vm_nic" {
  name                = "nic-mgmt-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_virtual_network.vnet]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "mgmt_vm" {
  name                = "vm-mgmt"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"

  admin_username      = "azureuser"
  admin_password      = "ChangeThis!123"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.mgmt_vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}
