# Azure Tools
Tools to assist in integrating Secure Workload in your Azure environment

The CSW Azure Connector script come in two flavors, a powershell and a terraform variant. 

Execute only ONE of these scripts! 

For the terraform variant:
</br>
[Authenticate using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
</br>
Don't have Azure CLI 😢
[Install the Azure CLI](https://learn.microsoft.com/en-us/dotnet/azure/install-azure-cli)
</br>
Then:
</br>`terraform init`
</br>`terraform plan`
</br>`terraform apply`

For the powershell variant:

Ensure the `Az` module is installed. With a powershell opened as administrator:

`Install-Module Az`
</br>`Import-Module Az`

For more information please see the following links:

[Install Azure Az Powershell module](https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.0.1)
</br>[Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
</br>[Terraform Azure Active Directory Provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)