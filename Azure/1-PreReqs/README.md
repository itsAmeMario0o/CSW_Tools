# Enable NSG Flow Logging
These scripts will guide you in:
1. Creating a storage account to hold the flow logs
2. Create a network watcher instance to enable flow visibility
3. Enable flow logging on a per NSG basis

# Nota Bene:
- Storage accounts must be in the same region as the NSGs
- Enable flow logging on the VNET NSG

While not necessary, it is helpful to have Azure Storage Explorer:

[Azure Storage Explorer](https://azure.microsoft.com/en-us/products/storage/storage-explorer/#overview)

Lastly, these scripts are intended to be used for smaller scale changes.
For bulk configuration use [Azure Terrfy](https://github.com/Azure/aztfy)

For more information please see the following links:

[Intro to flow logging for NSGs](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview)

[Create a storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-powershell)

[Create a Azure Network Watcher instance](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-create)

[Configure NSG Flow Logging](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-powershell)