terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.49.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "aseepractice" {
    name = "aseetfrg"
    location = "eastus"
  
}

# resource "azurerm_storage_account" "aseestorage" {
#    name = "aseepractice"
#    resource_group_name = azurerm_resource_group.aseepractice.name
#    location = azurerm_resource_group.aseepractice.location
#    access_tier = "Standard"
#    account_replication_type = "GRS"
#    tags = {
#     environment = "staging"
#    }
# }