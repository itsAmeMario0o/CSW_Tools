output "vm_ssh" {
    value = tls_private_key.vm_ssh.private_key_pem
    sensitive = true
}
output "workloadconnector_ip" {
    value = azurerm_linux_virtual_machine.workloadconnector.private_ip_address
}