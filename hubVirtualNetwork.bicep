@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param parRegion string = resourceGroup().location

@description('The Name of the Virtual Network.')
param parVirtualNetworkName string

resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: parVirtualNetworkName
  location: parRegion
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'dns-resolver-inbound'
        properties: {
          addressPrefix: '10.0.20.0/25'
        }
      }
      {
        name: 'dns-resolver-outbound'
        properties: {
          addressPrefix: '10.0.20.128/25'
        }
      }
    ]
  }
}
// passing hub vnet ID to main.bicep
output outHubVnetId string = resVirtualNetwork.id
