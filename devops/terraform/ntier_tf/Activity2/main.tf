resource "azurerm_resource_group" "scriptrg" {
  location = var.location
  name     = var.names.resource_group
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
}

resource "azurerm_virtual_network" "scriptvnet" {
  name                = var.names.vnet
  resource_group_name = azurerm_resource_group.scriptrg.name
  location            = azurerm_resource_group.scriptrg.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
  depends_on = [
    azurerm_resource_group.scriptrg
  ]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.names.subnet
  resource_group_name  = azurerm_resource_group.scriptrg.name
  virtual_network_name = azurerm_virtual_network.scriptvnet.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [
    azurerm_virtual_network.scriptvnet
  ]
}

resource "azurerm_network_interface" "vmscript_nic" {
  name                = var.network_interface_info.name
  location            = azurerm_resource_group.scriptrg.location
  resource_group_name = azurerm_resource_group.scriptrg.name

  ip_configuration {
    name                          = var.network_interface_info.ip_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.network_interface_info.ip_allocation_method
  }
  depends_on = [
    azurerm_subnet.subnet
  ]
}

resource "azurerm_linux_virtual_machine" "vmscript" {
  name                            = var.vm_info.name
  resource_group_name             = azurerm_resource_group.scriptrg.name
  location                        = azurerm_resource_group.scriptrg.location
  size                            = var.vm_info.size
  admin_username                  = var.vm_info.username
  admin_password                  = var.vm_info.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vmscript_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.vmscript_nic
  ]
}

resource "null_resource" "executor" {
  triggers = {
    rollout_version = var.rollout_version
  }

  connection {
    type        = "ssh"
    user        = azurerm_linux_virtual_machine.vmscript.admin_username
    private_key = file("~/.ssh/id_rsa")
    host        = azurerm_linux_virtual_machine.vmscript.public_ip_address
  }
  provisioner "local-exec" {
    command = "/bin/bash script.sh"
  }

}