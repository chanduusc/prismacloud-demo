resource "azurerm_container_registry" "acr" {
  count               = var.create_acr ? 1 : 0
  name                = var.image_repository
  resource_group_name = azurerm_resource_group.rg[0].name
  sku                 = "Basic"
  location            = var.region
  tags = merge(var.acr_tags, {
    yor_trace = "162b8f98-5b77-45bd-87c7-7281b6916436"
  })
}

resource "azurerm_role_assignment" "sp_acr_role" {
  count                = var.create_acr ? 1 : 0
  scope                = azurerm_container_registry.acr[count.index].id
  role_definition_name = "acrpush"
  principal_id         = azuread_service_principal.sp[count.index].id
}

data "azurerm_kubernetes_cluster" "aks" {
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
  name                = azurerm_kubernetes_cluster.aks_cluster.name
}

resource "azurerm_role_assignment" "aks_acr_role" {
  count                = var.create_acr ? 1 : 0
  scope                = azurerm_container_registry.acr[count.index].id
  role_definition_name = "acrpull"
  principal_id         = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
