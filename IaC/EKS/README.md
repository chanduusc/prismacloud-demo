# AWS Infrastructure for Prisma Cloud Demo
Required Terraform variables:
| Variable | Description | Example |
| --- | --- | --- |
| `trusted_networks` | List of strings containing trusted CIDRs | `["198.51.100.1/32", "198.51.100.2/32"]` |
| `demo_user_username` | Username for your IAM demo-user | `demo-user` |
| `gh_token` | GitHub token with r/w access to the specific repo secrets | `github_pat_XXX` |
| `gh_repo` | Name of the GitHub repository | `pc-demo` |
