######################################################
#
#           Enable NSG Flow Logging on NSG
#     
######################################################


# Enable Insights resource provider
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights


# The following will enable flow logging on a individual NSG

# Specify parameters
$rgNW = "NetworkWatcherRG"
$nameNW = "NetworkWatcher_eastus"
$rgNSG = "RESOURCE GROUP"           # Resource Group where the NSG resides
$nameNSG = "NSG NAME"               # NSG can be at subnet or instance level
$rgStorage = "FlowRG"               # Resource Group where the storage account resides
$nameStorage = "flowloggy"

# Specify network watcher, NSGs, storage account and get network watcher flow log status
$NW = Get-AzNetworkWatcher -ResourceGroupName $rgNW -Name $nameNW
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $rgNSG -Name $nameNSG
$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgStorage -Name $nameStorage
Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg.Id

#Configure Version 2 Flow Logs
Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $nsg.Id -StorageAccountId $storageAccount.Id -EnableFlowLog $true -FormatType Json -FormatVersion 2

#Query Flow Log Status
Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $nsg.Id