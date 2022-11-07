# Create a resource group
resource "azurerm_resource_group" "cswrg" {
    name     = "csw-rg"
    location = var.location.value
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "VNET"
    address_space       = ["10.10.0.0/16"]
    location            = var.location.value
    resource_group_name = azurerm_resource_group.cswrg.name
}

# Create subnet
resource "azurerm_subnet" "vnetsubnet" {
    name                 = "Subnet1"
    resource_group_name  = azurerm_resource_group.cswrg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.10.1.0/24"]
}

# Create a network interface for Secure Workload Connector appliance
resource "azurerm_network_interface" "workloadnic" {
    name                      = "Workload NIC"
    location                  = var.location.value
    resource_group_name       = azurerm_resource_group.cswrg.name

    ip_configuration {
        name                          = "WorkloadNicConf"
        subnet_id                     = azurerm_subnet.vnetsubnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

# Create Linux VM for Secure Workload Connector appliance
resource "azurerm_linux_virtual_machine" "connector" {
    name                  = "SecureWorkloadConnector"
    location              = var.location.value
    resource_group_name   = azurerm_resource_group.cswrg.name
    network_interface_ids = [azurerm_network_interface.workloadnic.id]
    size                  = "Standard_DS2_v2"

    os_disk {
        name              = "SecureWorkloadConnectorOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7_9-gen2"
        version   = "latest"
    }

    computer_name  = "SecureWorkloadConnector"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.vm_ssh.public_key_openssh
    }
}

# Create an SSH key
resource "tls_private_key" "vm_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}