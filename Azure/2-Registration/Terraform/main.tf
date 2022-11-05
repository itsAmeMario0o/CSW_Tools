data "azuread_client_config" "main" {}
data "azurerm_subscription" "primary" {}

provider "azuread" {
  # Auth via Azure CLI
}

provider "azurerm" {
  features {}
}