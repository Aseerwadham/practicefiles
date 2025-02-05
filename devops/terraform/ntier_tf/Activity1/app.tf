resource "azurerm_public_ip" "pubip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.ntierrg.name
  location            = azurerm_resource_group.ntierrg.location
  allocation_method   = "Dynamic"
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
}

resource "azurerm_network_interface" "appserver_nic" {
  name                = var.network_interface_info.name
  location            = azurerm_resource_group.ntierrg.location
  resource_group_name = azurerm_resource_group.ntierrg.name

  ip_configuration {
    name                          = var.network_interface_info.ip_name
    subnet_id                     = azurerm_subnet.subnets[var.network_interface_info.subnet_index].id
    private_ip_address_allocation = var.network_interface_info.ip_allocation_method
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}

resource "azurerm_linux_virtual_machine" "appserver" {
  name                            = var.vm_info.name
  resource_group_name             = azurerm_resource_group.ntierrg.name
  location                        = azurerm_resource_group.ntierrg.location
  size                            = var.vm_info.size
  admin_username                  = var.vm_info.username
  admin_password                  = var.vm_info.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.appserver_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.appserver_nic
  ]
}