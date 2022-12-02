targetScope = 'subscription'

@description('Provide location for resource group.')
param parRegion string

@description('Provide a name for the resource group.')
param parResourceGroupName string

resource resResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: parResourceGroupName
  location: parRegion
}

output outNetworkingResourceGroup string = resResourceGroup.name
output outNetworkingResourceGroupId string = resResourceGroup.id


