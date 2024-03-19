resource "random_string" "password" {
  length  = 6
  upper   = false
  special = false
}

data "azurerm_subscription" "configured" {
  subscription_id = var.subscription_id
}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = azurerm_kubernetes_cluster.aks_cluster.name
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  # checkov:skip=CKV_AZURE_115: Private Cluster would not work with GH actions
  # checkov:skip=CKV_AZURE_117: Disks are already encrypted at rest with Azure manged keys, which is sufficient for a demo cluster
  # checkov:skip=CKV_AZURE_4: No need for cluster telemetry (performance/availability) for a demo cluster
  # checkov:skip=CKV_AZURE_6: Cannot use trusted networks because of 200 IP limit with GH actions
  name                      = "${var.prefix}-${random_string.password.result}"
  location                  = var.region
  resource_group_name       = var.create_requirements ? azurerm_resource_group.rg[0].name : var.resource_group_name
  dns_prefix                = "${var.prefix}-${random_string.password.result}"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  automatic_channel_upgrade = "stable"
  depends_on = [
    azurerm_resource_provider_registration.ewip
  ]

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
    managed            = true
    tenant_id          = data.azurerm_subscription.configured.tenant_id
    azure_rbac_enabled = true
  }
}

resource "azurerm_resource_provider_registration" "ewip" {
  name = "Microsoft.ContainerService"

  feature {
    name       = "EnableWorkloadIdentityPreview"
    registered = true
  }
}

resource "azurerm_user_assigned_identity" "cnappdemo" {
  name                = "${var.prefix}-wlid"
  resource_group_name = var.create_requirements ? azurerm_resource_group.rg[0].name : var.resource_group_name
  location            = var.region
}

resource "azurerm_federated_identity_credential" "cnappdemo" {
  name                = "${var.prefix}-wlid"
  resource_group_name = azurerm_user_assigned_identity.cnappdemo.resource_group_name
  issuer              = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.cnappdemo.id
  audience            = ["api://AzureADTokenExchange"]
  subject             = "system:serviceaccount:default:workload-identity-sa"
}

resource "azurerm_role_assignment" "admin_aks_rbac" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_client_config.current.object_id
  scope                = azurerm_kubernetes_cluster.aks_cluster.id
}

resource "azurerm_role_assignment" "sp_aks_role" {
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.create_requirements ? azuread_service_principal.sp[0].id : var.client_id
  scope                = azurerm_kubernetes_cluster.aks_cluster.id
}

resource "azurerm_role_assignment" "sp_aks_rbac" {
  role_definition_name = "Azure Kubernetes Service RBAC Writer"
  principal_id         = var.create_requirements ? azuread_service_principal.sp[0].id : var.client_id
  scope                = "${azurerm_kubernetes_cluster.aks_cluster.id}/namespaces/default"
}
