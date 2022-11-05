######################################################
#
#       Create Network Watcher Instance
#       Optional - Get Network Watcher information
#
######################################################


# To analyze traffic, you need to enable a network watcher in each region 
# that you have network security groups that you want to analyze traffic for

# NOTE - When you create or update a virtual network in your subscription, 
# a network watcher will be enabled AUTOMATICALLY in your virtual network's region

# Get-AzNetworkWatcher

# OPTIONAL - If a network watcher is NOT enabled

$resourceGroup = "NetworkWatcherRG"  
$nameNW = "NetworkWatcher_eastus"  # Network Watcher per Region      
$location = "eastus"               # Location must be in same region as VNETs

New-AzResourceGroup -Name $resourceGroup -Location $location
New-AzNetworkWatcher -Name $nameNW -ResourceGroupName $resourceGroup -Location $location