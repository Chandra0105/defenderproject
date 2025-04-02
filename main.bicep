param webAppName string = 'webappjaya1'
param location string = resourceGroup().location
param skuName string = 'F1' // Change to a higher SKU for production use
param policyDefinitionId string = '/providers/Microsoft.Authorization/policyDefinitions/b40e7bcd-a1e5-47fe-b9cf-2f534d0bfb7d'
param policyAssignmentName string = 'DefenderForCloudPolicyAssignment' // Name of the policy assignment

// Create an App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'AppServicePlanjaya1'
  location: location
  sku: {
    name: skuName
    tier: 'Free'
    size: 'F1'
    capacity: 1
  }
}

// Create a Web App
resource webApp 'Microsoft.Web/sites@2021-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource defenderPolicyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyAssignmentName
  location: 'centralindia' // Replace with a region supported by Managed Identities
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: policyDefinitionId
    scope: resourceGroup().id
  }
}


// Output the Web App URL
output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
