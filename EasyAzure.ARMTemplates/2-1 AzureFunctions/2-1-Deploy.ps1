
#I put my $subscriptionid in a git ignored txt file to avoid putting it in a public repo.  Replace the following line with $subscriptionid = '<yoursubscriptionID>'
$subscriptionid = Get-Content -Path '../subscription-id.txt' | Out-String
$subscriptionid = $subscriptionid.Trim()

Set-AzContext $subscriptionid

$RGName = 'EasyAzure'
$Location = 'eastus'

# Create a resource group.
New-AzResourceGroup $RGName $Location -Force


New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile './2-1-AzureFunctions.bicep' -WhatIf

