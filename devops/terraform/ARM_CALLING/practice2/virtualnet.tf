resource "azurerm_resource_group" "deployarm_rg" {
  name     = "armdeploy-resources"
  location = var.location
}

resource "azurerm_resource_group_template_deployment" "deployarm_template" {
  name                = "deployarmtemplate"
  resource_group_name = azurerm_resource_group.deployarm_rg.name
  deployment_mode     = "Incremental"
  template_content    = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2022-07-01",
            "name": "aseevnet",
            "location": "East US",
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [ "10.0.0.0/16" ]
                },
                "subnets": [
                    {
                        "name": "subnet1",
                        "properties": {
                            "addressPrefix": "10.0.0.0/24"
                        }
                    }
                ]
            }
        }
    ]
  }  
  TEMPLATE
}