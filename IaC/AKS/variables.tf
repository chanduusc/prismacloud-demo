############COMMON-VARIABLES########################

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "resource_group_name" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "image_repository" {}
variable "network_plugin" {
  default = "azure"
}
variable "network_policy" {
  default = "azure"
}

variable "region" {
  default = "North Central US"
}

variable "node_count" {
  default = 3
}
variable "min_node_count" {
  default = 2
}
variable "max_node_count" {
  default = 32
}
variable "node_size" {
  default = "Standard_DS3_v2"
}

variable "kube_version" {
  default = "1.15.10"
}

variable "prefix" {}

variable "create_requirements" {
  type        = bool
  description = "Create rg/vnet/subnet/sp requirement resources instead of using names from vars"
  default     = false
}

variable "create_acr" {
  type        = bool
  description = "Create ACR. If this is set to true, create_requirements must also be true"
  default     = false
}

variable "acr_tags" {
  type    = map(any)
  default = null
}
