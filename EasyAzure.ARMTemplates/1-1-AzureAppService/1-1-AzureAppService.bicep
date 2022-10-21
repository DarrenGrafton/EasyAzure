@description('This will be the name of the App Service and App Service plan')
param appName string = 'easyazure'


param location string = resourceGroup().location // Location for all resources



param appSuffix string = uniqueString(resourceGroup().id) // unique suffix to ensure the app service plan and app service names are unique
param sku string = 'F1' // The SKU of App Service Plan
//param repositoryUrl string = 'https://github.com/Azure-Samples/nodejs-docs-hello-world'
//param branch string = 'master'

var appServicePlanName = toLower('plan-${appName}-${appSuffix}')
var webSiteName = toLower('${appName}-${appSuffix}')


resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'windows'
}
resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    
  }
}
//resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
//  name: '${appService.name}/web'
//  properties: {
//    repoUrl: repositoryUrl
//    branch: branch
//    isManualIntegration: true
//  }
//}