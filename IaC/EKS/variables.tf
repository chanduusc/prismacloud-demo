variable "cluster_name" {
  type    = string
  default = "pc-demo-eks"
}

variable "ecr_repo_name" {
  type    = string
  default = "pythonscript"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "trusted_networks" {
  type        = list(any)
  description = "List of strings containing trusted CIDRs"
}

variable "demo_user_username" {
  type        = string
  description = "Username for the demo user to to grant access to ECR"
}

variable "eks_tags" {
  type    = map(any)
  default = null
}

variable "gh_token" {
  type = string
}

variable "gh_repo" {
  type = string
}

variable "run_provisioner" {
  type    = bool
  default = false
}

variable "provisioner_path" {
  type    = string
  default = "echo You must define provisioner_path; exit 1"
}

variable "argocd_git_repo" {
  type    = string
  default = null
}

variable "pcc_user" {
  type    = string
  default = null
}

variable "pcc_password" {
  type    = string
  default = null
}

variable "pcc_console" {
  type    = string
  default = null
}

variable "s3_bucket_name" {
  type = string
}
