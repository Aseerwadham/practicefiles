provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aseevm" {
  name     = var.resource_group_name
  location = var.location
}

module "linuxservers" {
  source              = "./Modules/*"
  resource_group_name = azurerm_resource_group.aseevm.name
  depends_on = [azurerm_resource_group.aseevm]
}

output "imageref" {
  value = module.azurerm_linux_virtual_machine.source_image_reference
}