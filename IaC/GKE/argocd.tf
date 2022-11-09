resource "null_resource" "run_provisioner" {
  count = var.run_provisioner ? 1 : 0
  provisioner "local-exec" {
    environment = {
      CSP                      = "GCP",
      GCP_GKE_NAME             = google_container_cluster.cluster.name,
      GCP_ZONE                 = google_container_cluster.cluster.location,
      ARGOCD_GITOPS_REPOSITORY = var.argocd_git_repo,
      GITHUB_TOKEN             = var.gh_token,
      PCC_USER                 = var.pcc_user,
      PCC_PASSWORD             = var.pcc_password,
      PCC_CONSOLE              = var.pcc_console
    }
    command = var.provisioner_path
  }
}
