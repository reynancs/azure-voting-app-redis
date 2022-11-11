variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default     = "myResourceGroup"
  description = "The resource group name"
}

###
variable "azurerm_container_registry" {
  default     = "reynancs"
  description = "The Azure Container Registry Resource (ACR)"
}


###
variable "azurerm_kubernetes_cluster" {
  default = "myAKSCluster"
}

variable "dns_prefix" {
  default = "myAKSCluster-dns"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}