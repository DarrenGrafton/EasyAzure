#Need Az powershell
#https://learn.microsoft.com/en-us/powershell/azure/?view=azps-9.0.0
#https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.0.0


#Need Bicep
#https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#windows


#I put my $subscriptionid in a git ignored txt file to avoid putting it in a public repo.  Replace the following line with $subscriptionid = '<yoursubscriptionID>'
$subscriptionid = Get-Content -Path '../subscription-id.txt' | Out-String

#Connect-AzAccount
Set-AzContext $subscriptionid


$RGName = 'EasyAzure'
$Location = 'eastus'

# Create a resource group.
New-AzResourceGroup $RGName $Location

$params = @{
    appName = 'easyazure'
}

New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile './1-1-AzureAppService.bicep' -TemplateParameterObject $params

