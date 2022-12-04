@description('This will be the name of the App Service and App Service plan')
param appName string = 'easyazure'


param location string = resourceGroup().location // Location for all resources



param appSuffix string = uniqueString(resourceGroup().id) // unique suffix to ensure the app service plan and app service names are unique
param sku string = 'S1' // The SKU of App Service Plan
//param repositoryUrl string = 'https://github.com/Azure-Samples/nodejs-docs-hello-world'
//param branch string = 'master'

var appServicePlanName = toLower('plan-${appName}-${appSuffix}')
var webSiteName = toLower('${appName}-${appSuffix}')


resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: false //reserved false means we want a windows app service plan
  }
  sku: {
    name: sku
  }
  kind: 'windows' // this doesn't set the plan OS to windows, the reserved flag above does.  Leaving this here in case...
}
resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    
  }
}