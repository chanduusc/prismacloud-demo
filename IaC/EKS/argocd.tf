resource "null_resource" "run_provisioner" {
  count = var.run_provisioner ? 1 : 0
  provisioner "local-exec" {
    environment = {
      CSP                      = "AWS",
      AWS_EKS_NAME             = module.eks.cluster_id,
      AWS_EKS_VERSION          = module.eks.cluster_version,
      ARGOCD_GITOPS_REPOSITORY = var.argocd_git_repo,
      GITHUB_TOKEN             = var.gh_token,
      PCC_USER                 = var.pcc_user,
      PCC_PASSWORD             = var.pcc_password,
      PCC_CONSOLE              = var.pcc_console
    }
    command = var.provisioner_path
  }
}
