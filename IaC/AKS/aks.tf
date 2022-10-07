resource "random_string" "password" {
  length  = 6
  upper   = false
  special = false
}
provider "random" {}

provider "azurerm" {
  #version = "=1.38.0"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.prefix}-${random_string.password.result}"
  location            = var.region
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-${random_string.password.result}"

  default_node_pool {
    name       = "poolone"
    node_count = var.node_count
    vm_size    = var.node_size
    enable_auto_scaling= true
    min_count           = var.node_count
    max_count           = var.max_node_count
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/${var.subnet_name}"
  }

  kubernetes_version = var.kube_version

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_policy
    dns_service_ip = "192.168.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr = "192.168.0.0/16"

  }
}


