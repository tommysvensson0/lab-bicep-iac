targetScope = 'subscription'

@description('Provide location for resource group.')
param parRegion string = 'swedencentral'

@description('Subscription ID for the deployment.')
param subscriptionId string = 'c960ecf7-324a-46ca-ac48-2ddb0baee7dc'

// declare resource group for private DNS zones
module dnsResourceGroup 'resourceGroup.bicep' = {
  scope: subscription(subscriptionId)
  name: 'create-rg-contoso-privateDnsZones'
  params: {
    parRegion: parRegion
    parResourceGroupName: 'rg-contoso-privateDnsZones'
  }
}

// declare private DNS zones
module privateDnsZones 'privateDnsZones.bicep' = {
  dependsOn: [
    dnsResourceGroup
  ]
  scope: resourceGroup(dnsResourceGroup.name)
  name: 'create-DNS-zones'
  params: {
    parLocation: parRegion
  }
}

// declare resource group for hub resources
module hubResourceGroup 'resourceGroup.bicep' = {
  scope: subscription(subscriptionId)
  name: 'create-rg-hub'
  params: {
    parRegion: parRegion
    parResourceGroupName: 'rg-hub'
  }
}

// create hub vnet
module hubVirtualNetwork 'hubVirtualNetwork.bicep' = {
  scope: resourceGroup(hubResourceGroup.name)
  name: 'create-hub-vnet'
  dependsOn: [
    hubResourceGroup
  ]
  params: {
    parRegion: parRegion
    parVirtualNetworkName: 'vnet-hub-swe'
  }
}

// declare private DNS resolver
module hubPrivateDnsResolver 'hubDnsResolver.bicep' = {
  scope: resourceGroup(hubResourceGroup.name)
  name: 'create-hub-dns-resolver'
  dependsOn: [
    hubVirtualNetwork
  ]
  params: {
    parRegion: parRegion
    parPrivateDnsResolverName: 'hub-private-dns-resolver'
    hubVnetId: hubVirtualNetwork.outputs.outHubVnetId
  }
}
