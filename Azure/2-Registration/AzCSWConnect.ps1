######################################################
#
#           Create a App Registration in AzureAD
#                  Client Secret Method
#
######################################################

# Define parameters
$appName = "Cisco Secure Workload"
$desc = "Cisco Secure Workload Registration"
$start = Get-Date
$end = $start.AddYears(1)
$seCreds = @{
    "DisplayName" = "CSW Secret"
    "StartDateTime" = $start
    "EndDateTime" = $end
}

# Create App Registration
New-AzADApplication -DisplayName $appName -Description $desc

# Delay for registration to propagate
Write-Output ""
Write-Output "Waiting for changes to propagate..."
Start-Sleep -Seconds 5

# Gather Tenant ID, Subscription ID, Object ID, Client ID
$tenant = $(Get-AzSubscription).TenantId
$subID = $(Get-AzSubscription).SubscriptionId
$objID = $(Get-AzADApplication -Filter "DisplayName eq '$appName'").Id
$clientID = $(Get-AzADApplication -Filter "DisplayName eq '$appName'").AppId

#[string]::IsNullOrEmpty($objID)

# Create and save secret value
$secret = $(New-AzADAppCredential -ObjectId $objID -PasswordCredentials $seCreds).SecretText

# Create Service Principal with Application
$sp = $(New-AzADServicePrincipal -ApplicationId $clientID).AppId

######################################################
#
#        Create a Azure RBAC custom role 
#        for Secure Workload App Registration
#
######################################################

Write-Output ""
Write-Output "Waiting for changes to propagate..."
Start-Sleep -Seconds 5

$subs = '/subscriptions/'+$subID

$role = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()
$role.Name = 'Cisco Secure Workload Role'
$role.Description = 'Cisco Secure Workload (CSW) generated policy.'
$role.IsCustom = $true
$role.AssignableScopes = $subs
$perms = 'Microsoft.Network/networkInterfaces/read','Microsoft.Network/networkInterfaces/write','Microsoft.Network/networkInterfaces/ipconfigurations/read'
$perms += 'Microsoft.Network/virtualNetworks/read','Microsoft.Network/virtualNetworks/subnets/read'
$perms += 'Microsoft.Compute/virtualMachines/read'
$perms += 'Microsoft.Network/publicIPAddresses/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/networkInterfaces/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/publicIPAddresses/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/vmSizes/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/virtualMachines/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/ipConfigurations/publicIPAddresses/read'
$perms += 'Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/ipConfigurations/read'
$perms += 'Microsoft.Network/networkWatchers/read','Microsoft.Network/networkWatchers/queryFlowLogStatus/action','Microsoft.Network/networkWatchers/flowLogs/read','Microsoft.Network/networkWatchers/flowLogs/write'
$perms += 'Microsoft.Storage/storageAccounts/listKeys/Action'
$perms += 'Microsoft.Authorization/permissions/read'
$perms += 'Microsoft.Network/networkSecurityGroups/read','Microsoft.Network/networkSecurityGroups/write'
$perms += 'Microsoft.Resources/subscriptions/resourceGroups/read'
$perms += 'Microsoft.Storage/storageAccounts/Read'
$perms += 'Microsoft.ContainerService/containerServices/read','Microsoft.ContainerService/managedClusters/agentPools/read','Microsoft.ContainerService/managedClusters/read'
$dperms = 'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
$role.Actions = $perms
$role.DataActions = $dperms

# Create Custom RBAC role
New-AzRoleDefinition -Role $role

######################################################
#
#        Assign custom role to registered app
#
######################################################

Write-Output ""
Write-Output "Waiting for changes to propagate..."
Start-Sleep -Seconds 5

# Assigns RBAC role to the registered app, SP
New-AzRoleAssignment -ApplicationId $sp  -RoleDefinitionName $role.Name

######################################################
#
#        Export info for CSW cluster configuration
#
######################################################

# Export info to CSV
$cswInfo = @{
    "SubscriptionID" = $subID
    "TenantID" = $tenant
    "ClientID" = $clientID
    "SecretKey" = $secret
}

Write-Output ""
Write-Output "Check current folder for CSV file with info to complete Azure CSW Connector"
$cswInfo | Export-CSV connector.csv -NoTypeInformation -Encoding UTF8