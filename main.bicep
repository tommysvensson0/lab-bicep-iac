targetScope = 'subscription'

@description('Provide location for spoke resource group.')
param parRegion string = 'swedencentral'

@description('Subscription ID for the deployment.')
param subscriptionId string = 'c960ecf7-324a-46ca-ac48-2ddb0baee7dc'

@description('Provide a name for the spoke resource group.')
param parDnsZonesResourceGroupName string = 'rg-contoso-privateDnsZones'

// create a resource group for private DNS Zones
module dnsResourceGroup 'resourceGroup.bicep' = {
  scope: subscription(subscriptionId)
  name: 'create-${parDnsZonesResourceGroupName}'
  params: {
    parRegion: parRegion
    parSpokeResourceGroupName: parDnsZonesResourceGroupName
    //parDnsZonesResourceGroupName: parDnsZonesResourceGroupName
  }
}

module privateDnsZones 'privateDnsZones.bicep' = {
  dependsOn: [
    dnsResourceGroup
  ]
  scope: resourceGroup(parDnsZonesResourceGroupName)
  name: 'create-DNS-zones'
  params: {
    parLocation: parRegion
  }
}
