resource "null_resource" "run_provisioner" {
  count = var.run_provisioner ? 1 : 0
  provisioner "local-exec" {
    environment = {
      CSP                      = "AZURE",
      AZURE_AKS_NAME           = azurerm_kubernetes_cluster.aks_cluster.name,
      AZURE_RG                 = azurerm_kubernetes_cluster.aks_cluster.resource_group_name,
      ARGOCD_GITOPS_REPOSITORY = var.argocd_git_repo,
      GITHUB_TOKEN             = var.gh_token,
      PCC_USER                 = var.pcc_user,
      PCC_PASSWORD             = var.pcc_password,
      PCC_CONSOLE              = var.pcc_console
    }
    command = var.provisioner_path
  }
}
