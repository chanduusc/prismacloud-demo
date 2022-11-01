# Azure Infrastructure for Prisma Cloud Demo
Required Terraform variables:
| Variable | Description | Example |
| --- | --- | --- |
| `subscription_id` | Azure subscription ID | `3af20890-a345-4789-ae66-e354df6680b9` |
| `prefix ` | Prefix for all reasource names | `username-pc-demo` | 
| `image_repository` | Name for the ACR repo. Ignored if `create_acr != true`. | `pythonserver` |
| `gh_token` | GitHub token with r/w access to the specific repo secrets | `github_pat_XXX` |
| `gh_repo` | Name of the GitHub repository | `pc-demo` |

Pre-requisites:
| Variable | Description | Example |
| --- | --- | --- |
| `create_requirements`| Create RG/vnet/subnet/sp | `true` |
| `create_acr` | Create ACR | `true` |

If the pre-requisites are manually created then provide the details:
| Variable | Description | Example |
| --- | --- | --- |
| `client_id` | Client ID for the Service Principal |  `61c9a3cd-000d-4a4d-963a-f28c7c050c02`
| `client_secret` | Client secret for the Service Principal | `abc123YB0MXBd9tOFRufFTbiQ1el.rF8S6_DvzuAJYQz2f` |
| `resource_group_name` | Name of the RG | `user-eks-rg` |
| `subnet_name ` | Name of the subnet | `user-eks-subnet` |
| `vnet_name` | Name of the vnet | `user-eks-vnet` |
