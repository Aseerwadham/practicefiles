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
resource "azurerm_public_ip" "pubip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.scriptrg.name
  location            = azurerm_resource_group.scriptrg.location
  allocation_method   = "Dynamic"
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
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
  user_data                       = filebase64("ansible.sh")
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
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.vmscript_nic
  ]
}

# resource "null_resource" "executor" {
#   triggers = {
#     rollout_version = var.rollout_version
#   }
#   connection {
#     type        = "ssh"
#     user        = azurerm_linux_virtual_machine.vmscript.admin_username
#     private_key = file("~/.ssh/id_rsa")
#     host        = azurerm_linux_virtual_machine.vmscript.public_ip_address
#   }
#   # provisioner "local-exec" {
#   #   command = "/bin/bash script.sh"
#   # }
#   provisioner "file" {
#   source      = "./nop.service"
#   destination = "/tmp/nop.service"

#   }
#   provisioner "remote-exec" {
#     inline = [
#       "wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb",
#       "sudo dpkg -i packages-microsoft-prod.deb",
#       "sudo apt-get update",
#       "sudo apt-get install -y apt-transport-https aspnetcore-runtime-7.0",
#       "mkdir /var/www/nopCommerce",
#       "cd /var/www/nopCommerce",
#       "sudo wget https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.2/nopCommerce_4.60.2_NoSource_linux_x64.zip",
#       "sudo apt-get install unzip",
#       "sudo unzip nopCommerce_4.60.2_NoSource_linux_x64.zip",
#       "sudo mkdir bin",
#       "sudo mkdir logs",
#       "cd ..",
#       "sudo chgrp -R www-data nopCommerce/",
#       "sudo chown -R www-data nopCommerce/",
#       "sudo systemctl start nopCommerce.service",
#       "sudo systemctl status nopCommerce.service"
#     ]
#   }
# }