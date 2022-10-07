# AWS Infrastructure for Prisma Cloud Demo
Required Terraform variables:
| Variable | Description | Example |
| --- | --- | ---|
| `trusted_networks` | List of strings containing trusted CIDRs | `["198.51.100.1/32", "198.51.100.2/32"]` |
| `demo_user_username` | Username for your IAM demo-user | `demo-user` |
