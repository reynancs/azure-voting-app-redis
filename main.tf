# Provisionamento de um Grupo de Recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Provisionamento de um Regra AcrPull para integrar o ACR ao Cluster
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

# Provisionamento de um Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                    = var.azurerm_container_registry
  resource_group_name     = var.resource_group_name
  location                = var.resource_group_location
  sku                     = "Basic"
  zone_redundancy_enabled = false
  admin_enabled           = false
}

# Provisionamento de um Azure Kubenertes Cluster (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.azurerm_kubernetes_cluster
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.azurerm_kubernetes_cluster

  default_node_pool {
    name       = "nodepool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet" # CNI
  }

  depends_on = [azurerm_resource_group.rg]

}

resource "local_file" "foo" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "kube_config.yaml"
}