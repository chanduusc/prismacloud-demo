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
variable "prefix" {
  default = "schandu"
}
variable "kube_version" {}