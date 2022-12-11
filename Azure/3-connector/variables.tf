variable location {
    type = map(string)
    default = {
      value = "East US"
      suffix = "eastus"
    }
}
variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}