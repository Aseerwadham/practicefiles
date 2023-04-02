@description('vnet address space')
param region string = location




var name string = 'rgname'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: rgname
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'app'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'web'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'db'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'mgmt'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}


resource appIPAddress 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: 'appip'
  location: region
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: 'dnsname'
    }
  }
}


resource nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: 'appnic'
  location: region
  properties: {
    ipConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: 'app.id'
          }
        }
      }
    ]
  }
}
resource nsg 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: 'appnsg'
  location: region
  properties: {
    securityRules: [
      {
        name: 'nsgRule'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'nsgRule'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}



resource ubuntuVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'azurevm'
  location: region
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ms'
    }
    osProfile: {
      computerName: 'computerName'
      adminUsername: 'adminUsername'
      adminPassword: 'adminPassword'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'name'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: 'id'
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'storageUri'
      }
    }
  }
}


