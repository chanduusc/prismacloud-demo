############COMMON-VARIABLES########################

variable "credentials" {}
variable "project" {}
variable "ssh-keys" {}
variable "service_account_email" {}
variable "service_account_scopes" {
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}


###### GKE Config #####
variable "region" {
  default = "us-west1"
}
variable "node_count" {
  default = 3
}
variable "general_purpose_machine_type" {
  default = "n1-standard-8"
}
variable "vpc_network_name" {}

variable "vpc_subnetwork_name" {}

variable "pod_ipv4_cidr_block" {
  default = "/18"
}

variable "svc_ipv4_cidr_block" {
  default = "/24"
}

variable "master_ipv4_cidr_block" {}


variable "corp_public_ip" {}
variable "prefix" {}
variable "kube_version" {}

variable "create_requirements" {
  type    = bool
  default = false
}

variable "crypto_keyring_name" {
  type = string
}

variable "crypto_key_name" {
  type = string
}

variable "gh_token" {
  type = string
}

variable "gh_repo" {
  type = string
}
