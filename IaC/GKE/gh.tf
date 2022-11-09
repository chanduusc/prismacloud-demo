provider "github" {
  token = var.gh_token
}

resource "github_actions_secret" "gke_sa_key" {
  # checkov:skip=CKV_GIT_4: the value is not in plain text (checkov bug)
  count           = var.create_requirements ? 1 : 0
  repository      = var.gh_repo
  secret_name     = "GKE_SA_KEY"
  plaintext_value = base64decode(google_service_account_key.sa_key[0].private_key)
}

resource "github_actions_secret" "gke_project" {
  count       = var.create_requirements ? 1 : 0
  repository  = var.gh_repo
  secret_name = "GKE_PROJECT"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = google_container_cluster.cluster.project
}

resource "github_actions_secret" "gke_cluster" {
  count       = var.create_requirements ? 1 : 0
  repository  = var.gh_repo
  secret_name = "GKE_CLUSTER"
  # checkov:skip=CKV_SECRET_6: not a secret
  plaintext_value = google_container_cluster.cluster.name
}

resource "github_actions_secret" "gke_zone" {
  count           = var.create_requirements ? 1 : 0
  repository      = var.gh_repo
  secret_name     = "GKE_ZONE"
  plaintext_value = google_container_cluster.cluster.location
}
