
## Secrets 
### Shared
| Secret | Description | Example |
| --- | --- | --- |
| `PCC_CONSOLE_URL` | Prisma Cloud console URL. To get the address for your Console, go to **Compute > Manage > System > Utilities**, and copy the string under **Path to Console**. | `https://us-west1.cloud.twistlock.com/us-3-123456789` |
| `PCC_USER` | Access Key ID of a user with the CI user role in Prisma Cloud | `7d875079-4f77-47d4-991f-5c30eef5733c`
| `PCC_PASS` | Secret Key for the above Access Key ID | `c2VjcmV0IGtleXNlY3JldCBrZXk=`
### Azure
| Secret | Description | Example |
| --- | --- | --- |
| `AZURE_CREDENTIALS` | Service principal secrets JSON. If the provided AKS IaC is use then this is the "value" in the output of `terraform output -json` | <pre>{<br>    "clientId": "61c9a3cd-000d-4a4d-963a-f28c7c050c02",<br/>    "clientSecret": "abc123YB0MXBd9tOFRufFTbiQ1el.rF8S6_DvzuAJYQz2f",<br/>    "subscriptionId": "fcf0640e-4bc6-47b1-946a-608bacd2280f",<br/>    "tenantId": "cad4f40f-a8b8-4706-b85d-51a9311a6bb1",<br/>    (...)<br/>}</pre> |
| `REGISTRY_LOGIN_SERVER` | ACR repo FQDN | `pythonserver.azurecr.io` |
| `REGISTRY_USERNAME` | `clientId` value from `AZURE_CREDENTIALS` | `61c9a3cd-000d-4a4d-963a-f28c7c050c02` |
| `REGISTRY_PASSWORD` | `clientSecret` value from `AZURE_CREDENTIALS` | `abc123YB0MXBd9tOFRufFTbiQ1el.rF8S6_DvzuAJYQz2f` |
| `RESOURCE_GROUP` | Name od the RG containing EKS | `pc-demo-rg` |
| `CLUSTER_NAME` | EKS cluster name | `pc-demo-eks` |

### AWS
| Secret | Description | Example |
| --- | --- | --- |
| `AWS_ACCESS_KEY_ID` | AWS_ACCESS_KEY_ID for your IAM demo-user | `AKIAIOSFODNN7EXAMPLE` |
`AWS_SECRET_ACCESS_KEY` |AWS_SECRET_ACCESS_KEY for your IAM demo-user | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_REGION` | The AWS region where ECR is located in | `eu-central-1` |
`KUBE_CONFIG_DATA` | `cat $HOME/.kube/config \| base64` | `YmFzZTY0IG...V4YW1wbGU=` |
`REPO_NAME` | The name of the ECR repository | `pythonscript` |
