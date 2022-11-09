provider "github" {
  token = var.gh_token
}

resource "github_actions_secret" "azure_credentials" {
  count       = var.create_requirements ? 1 : 0
  repository  = var.gh_repo
  secret_name = "AZURE_CREDENTIALS"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = jsonencode(
    {
      clientId       = azuread_service_principal.sp[0].application_id
      clientSecret   = azuread_service_principal_password.sp_pwd[0].value
      subscriptionId = var.subscription_id
      tenantId       = azuread_service_principal.sp[0].application_tenant_id
    }
  )
}

resource "github_actions_secret" "registry_username" {
  count       = var.create_acr ? 1 : 0
  repository  = var.gh_repo
  secret_name = "REGISTRY_USERNAME"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = azuread_service_principal.sp[0].application_id
}

resource "github_actions_secret" "registry_pasword" {
  count       = var.create_acr ? 1 : 0
  repository  = var.gh_repo
  secret_name = "REGISTRY_PASSWORD"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = azuread_service_principal_password.sp_pwd[0].value
}

resource "github_actions_secret" "registry_login_server" {
  count       = var.create_acr ? 1 : 0
  repository  = var.gh_repo
  secret_name = "REGISTRY_LOGIN_SERVER"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = azurerm_container_registry.acr[count.index].login_server
}

resource "github_actions_secret" "resource_group" {
  count       = var.create_requirements ? 1 : 0
  repository  = var.gh_repo
  secret_name = "RESOURCE_GROUP"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
}

resource "github_actions_secret" "cluster_name" {
  count       = var.create_requirements ? 1 : 0
  repository  = var.gh_repo
  secret_name = "CLUSTER_NAME"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = azurerm_kubernetes_cluster.aks_cluster.name
}
