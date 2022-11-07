variable location {
    type = map(string)
    default = {
      value = "Central US"
      suffix = "centralus"
    }
}
variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}