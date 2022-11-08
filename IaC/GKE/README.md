# GCP Infrastructure for Prisma Cloud Demo
Required Terraform variables:
| Variable | Description | Example |
| --- | --- | --- |
| `crypto_key_name` | Name of the key used for encrypting application layer secrets  | `pc-demo-key` | 
| `crypto_keyring_name` | Name of the key ring containing `crypto_key_name` | `pc-demo-keyring` |
| `gh_token` | GitHub token with r/w access to the specific repo secrets | `github_pat_XXX` |
| `gh_repo` | Name of the GitHub repository | `pc-demo` |

Since Terraform cannot delete keys and keyrings, these should be created manually:
https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets#creating-key

The step `Grant permission to use the key` from the guide above is not needed as IAM is taken care of by Terraform code.

Pre-requisites:
| Variable | Description | Example |
| --- | --- | --- |
| `create_requirements`| Create VPC/subnet/SA/IAM | `true` |
