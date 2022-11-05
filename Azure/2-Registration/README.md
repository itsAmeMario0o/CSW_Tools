# Secure Workload App Registration

These scripts will guide you to:
1. Create a application registration in Azure AD
2. Create a custom role and assign it permissions
</br>
Powershell - Create a CSV file with information to complete the connector integration</br>
Terraform - The output and `terraform.tfstate` will have the information to complete the connector integration
</br></br>For the powershell script, ensure AzureAD module is installed. With a powershell opened as administrator:

`Install-Module AzureAD`</br>`Import-Module AzureAD`</br>`Import-module Az.Resources`

On a windows machine and cannot run the script due to execution policy?</br>`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

The `AzCSWConnect.ps1` script creates a client secret for the connector.
</br></br>The `CSWConnector.tf` will save the client secret in the `terraform.tfstate` that is generated. Look for the `"client_secret"` and its associated value.

Secure Workload also supports the use of certificates. 

For more information please see the following links:

[Application and service principal objects](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals)
[Create Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles-powershell)