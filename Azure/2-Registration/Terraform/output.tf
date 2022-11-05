output "client_secret" {  
  value = azuread_application_password.secret.value
  sensitive = true
}
output "client_id" {
  value = azuread_application.secureworkload-app.application_id
}
output "tenant_id" {
  value = data.azuread_client_config.main.tenant_id
}
output "subscription_id" {
  value = data.azurerm_subscription.primary.id
}