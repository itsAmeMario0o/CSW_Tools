######################################################
#
#     Create a Storage Account with Blob storage
#
######################################################

# Sign into Azure

Connect-AzAccount

# Create a resource group for our storage account

$resourceGroup = "FlowRG"          
$location = "eastus"               # Location must be in same region as NSGs

New-AzResourceGroup -Name $resourceGroup -Location $location

# Create storage account
# Note: -SkuName and -Kind can vary

$storageName = "flowloggy"       # MUST BE UNIQUE & lowercase

New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageName `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind StorageV2