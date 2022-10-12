resource "google_compute_network" "vpc" {
  count                   = var.create_requirements ? 1 : 0
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count                    = var.create_requirements ? 1 : 0
  name                     = "${var.prefix}-subnet"
  ip_cidr_range            = "10.0.0.0/22"
  network                  = google_compute_network.vpc[0].id
  private_ip_google_access = true
  log_config {
    flow_sampling = 0.5
  }
}

resource "google_service_account" "service_account" {
  count      = var.create_requirements ? 1 : 0
  account_id = "${var.prefix}-githubaction"
}

resource "google_service_account_key" "sa_key" {
  count              = var.create_requirements ? 1 : 0
  service_account_id = google_service_account.service_account[count.index].name
}

resource "google_project_iam_binding" "sa_role" {
  for_each = var.create_requirements ? toset([
    "roles/container.developer", # deploy to k8s
    "roles/storage.admin" # push to gcr
  ]) : toset([])
  role    = each.key
  members = ["serviceAccount:${google_service_account.service_account[0].email}"]
  project = var.project
}

output "sa_key" {
  value     = var.create_requirements ? google_service_account_key.sa_key[0].private_key : null
  sensitive = true
}
