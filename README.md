
## Secrets
### Shared
| Secret | Description | Example |
| --- |--- | --- |
| `PCC_CONSOLE_URL` | Prisma Cloud console URL. To get the address for your Console, go to **Compute > Manage > System > Utilities**, and copy the string under **Path to Console**. | `https://us-west1.cloud.twistlock.com/us-3-123456789` |
| `PCC_USER` | Access Key ID of a user with the CI user role in Prisma Cloud | `7d875079-4f77-47d4-991f-5c30eef5733c`
| `PCC_PASS` | Secret Key for the above Access Key ID | `c2VjcmV0IGtleXNlY3JldCBrZXk=`
### AWS
| Secret | Description | Example |
| --- |--- | --- |
| `AWS_ACCESS_KEY_ID` | AWS_ACCESS_KEY_ID for your IAM demo-user | `AKIAIOSFODNN7EXAMPLE` |
`AWS_SECRET_ACCESS_KEY` | AWS_SECRET_ACCESS_KEY for your IAM demo-user | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_REGION` | The AWS region where ECR is located in | `eu-central-1` |
`KUBE_CONFIG_DATA` | `aws eks update-kubeconfig --dry-run --name <aks_cluster_name> \| base64` | `YmFzZTY0IG...V4YW1wbGU=` |
`REPO_NAME` | The name of the ECR repository | `pythonscript`
