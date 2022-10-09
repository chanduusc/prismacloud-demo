resource "random_string" "password" {
  length  = 6
  upper   = false
  special = false
}

provider "azurerm" {
  #version = "=1.38.0"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args        = ["get-token", "-l", "azurecli", "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630"]
  }
}

data "azurerm_subscription" "configured" {
  subscription_id = var.subscription_id
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  # checkov:skip=CKV_AZURE_115: Private Cluster would not work with GH actions
  # checkov:skip=CKV_AZURE_117: Disks are already encrypted at rest with Azure manged keys, which is sufficient for a demo cluster
  # checkov:skip=CKV_AZURE_4: No need for cluster telemetry (performance/availability) for a demo cluster
  # checkov:skip=CKV_AZURE_6: Cannot use trusted networks because of 200 IP limit with GH actions
  name                = "${var.prefix}-${random_string.password.result}"
  location            = var.region
  resource_group_name = var.create_requirements ? azurerm_resource_group.rg[0].name : var.resource_group_name
  dns_prefix          = "${var.prefix}-${random_string.password.result}"

  default_node_pool {
    name                = "poolone"
    node_count          = var.node_count
    vm_size             = var.node_size
    enable_auto_scaling = true
    min_count           = var.node_count
    max_count           = var.max_node_count
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = var.create_requirements ? tolist(azurerm_virtual_network.vnet[0].subnet)[0].id : "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/${var.subnet_name}"
  }

  kubernetes_version = var.kube_version

  /*   service_principal {
    client_id     = var.create_requirements ? azuread_application.app[0].application_id : var.client_id
    client_secret = var.create_requirements ? azuread_service_principal_password.sp_pwd[0].value : var.client_secret
  } */

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = "192.168.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "192.168.0.0/16"

  }

  local_account_disabled            = true
  role_based_access_control_enabled = true
  azure_policy_enabled              = true

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = ["ac3afdc3-9968-4300-b8de-82a1b6defba7"]
    tenant_id              = data.azurerm_subscription.configured.tenant_id
    # azure_rbac_enabled = true
  }
}

# Cannot be used until https://github.com/microsoftgraph/msgraph-metadata/issues/92 is fixed
# resource "azuread_group" "aks_admin_ad_group" {
#   display_name     = "${prefix}-aks-admin"
#   members = [data.azuread_client_config.current.object_id]
#   security_enabled = true
# }

resource "kubernetes_role_binding" "edit_default_namespace_role_mapping" {
  # checkov:skip=CKV_K8S_21: Default namespace used by deployments
  metadata {
    name      = "edit-default-namespace-role-mapping"
    namespace = "default"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }
  subject {
    kind      = "User"
    name      = var.create_requirements ? azuread_service_principal.sp[0].id : var.client_id
    api_group = "rbac.authorization.k8s.io"
  }
}
