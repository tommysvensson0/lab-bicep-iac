@description('The Azure Region to deploy the resources into. Default: resourceGroup().location')
param parRegion string = resourceGroup().location

@description('The Name of the Private DNS resolver.')
param parPrivateDnsResolverName string

@description('The passed hub VNET ID')
param hubVnetId string

resource privateDnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: parPrivateDnsResolverName
  location: parRegion
  properties: {
    virtualNetwork: {
      id: hubVnetId
    }
  }
}
