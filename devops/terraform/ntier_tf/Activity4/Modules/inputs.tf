variable "location" {
  type    = string
  default = "eastus"
}
variable "names" {
  type = object({
    resource_group = string
    vnet           = string
    subnet         = string
  })
  default = {
    resource_group = "srciptrg"
    subnet         = "app"
    vnet           = "scriptvnet"
  }
}
variable "network_interface_info" {
  type = object({
    name                 = string
    ip_name              = string
    subnet_index         = string
    ip_allocation_method = string
  })
  default = {
    ip_allocation_method = "Dynamic"
    ip_name              = "vmscriptip"
    name                 = "vmscriptnic"
    subnet_index         = 1
  }
}
variable "vm_info" {
  type = object({
    name     = string
    username = string
    password = string
    size     = string
  })
  default = {
    name     = "script"
    password = "hipasswordhowareyou@1"
    size     = "Standard_B1s"
    username = "Aseeuser"
  }
}

