resource "github_actions_secret" "aws_region" {
  repository  = var.gh_repo
  secret_name = "AWS_REGION"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = var.region
}

resource "github_actions_secret" "aws_eks_name" {
  repository  = var.gh_repo
  secret_name = "AWS_EKS_NAME"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = local.cluster_name_full
}

resource "github_actions_secret" "ecr_repo_name" {
  repository      = var.gh_repo
  secret_name     = "REPO_NAME"
  plaintext_value = var.ecr_repo_name
}
