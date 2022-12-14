//https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-bicep?tabs=CLI

param location string = resourceGroup().location
param appName string = 'easyazure'
param appServicePlanName string = toLower('plan-easyazure-${uniqueString(resourceGroup().id)}')


var functionAppName = 'fn-${appName}-${uniqueString(resourceGroup().id)}'
var applicationInsightsName = 'appi-${appName}funcs-${uniqueString(resourceGroup().id)}'
var runtime = 'dotnet'
var storageAccountType = 'Standard_LRS'

var storageAccountName = 'steazfncs${uniqueString(resourceGroup().id)}'
var functionWorkerRuntime = runtime

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
}

resource existingHostingPlan 'Microsoft.Web/serverfarms@2021-03-01' existing =  {
  name: appServicePlanName
}

resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = if (existingHostingPlan.id == null) {
  name: appServicePlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: (existingHostingPlan.id==null ? existingHostingPlan.id : hostingPlan.id)
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~10'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionWorkerRuntime
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}
