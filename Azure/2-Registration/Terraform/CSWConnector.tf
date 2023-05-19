######################################################
#
#           Create a App Registration in AzureAD
#                  Client Secret Method
#
######################################################

# Create Application
resource "azuread_application" "secureworkload-app" {
  display_name     = "Cisco Secure Workload"
  prevent_duplicate_names = true

  feature_tags {
    enterprise = true
    gallery    = true
  }
}

# Define key rotation 
resource "time_rotating" "rotate" {
  rotation_days = 90
}

# Create a Client Secret
resource "azuread_application_password" "secret" {
  application_object_id = azuread_application.secureworkload-app.object_id
  rotate_when_changed = {
    rotation = time_rotating.rotate.id
  }
}

# Create Service Principal
resource "azuread_service_principal" "secureworkload-sp" {
  application_id = azuread_application.secureworkload-app.application_id
  app_role_assignment_required = false

  feature_tags {
    enterprise = true
    gallery    = true
  }
}
# Create a custom role for CSW
resource "azurerm_role_definition" "secureworkload-role" {
  name        = "Custom Role - CSW"
  scope       = data.azurerm_subscription.primary.id
  description = "Cisco Secure Workload (CSW) generated policy."

  permissions {
    actions = [
      "Microsoft.Network/networkInterfaces/read",
      "Microsoft.Network/networkInterfaces/ipconfigurations/read",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Compute/virtualMachineScaleSets/read",
      "Microsoft.Compute/virtualMachineScaleSets/networkInterfaces/read",
      "Microsoft.Compute/virtualMachineScaleSets/publicIPAddresses/read",
      "Microsoft.Compute/virtualMachineScaleSets/vmSizes/read",
      "Microsoft.Compute/virtualMachineScaleSets/virtualMachines/read",
      "Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/read",
      "Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/ipConfigurations/publicIPAddresses/read",
      "Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/ipConfigurations/read",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/networkWatchers/read",
      "Microsoft.Network/networkWatchers/flowLogs/read",
      "Microsoft.Network/networkWatchers/queryFlowLogStatus/action",
      "Microsoft.Storage/storageAccounts/listKeys/Action",
      "Microsoft.Storage/storageAccounts/Read",
      "Microsoft.Authorization/permissions/read",
      "Microsoft.Network/networkSecurityGroups/read",
      "Microsoft.Network/networkSecurityGroups/write",
      "Microsoft.Network/networkSecurityGroups/delete",
      "Microsoft.Network/networkSecurityGroups/join/action",
      "Microsoft.Network/networkInterfaces/write",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/networkWatchers/flowLogs/write",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Network/publicIPAddresses/join/action",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action",
      "Microsoft.ContainerService/managedClusters/agentPools/read",
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
    ]
  }
}

# Assign custom role to service principal
resource "azurerm_role_assignment" "assignrole" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.secureworkload-role.role_definition_resource_id
  principal_id       = azuread_service_principal.secureworkload-sp.object_id
}