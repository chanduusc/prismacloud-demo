Complete CNAPP demo using Prisma Cloud demonstrating Cloud Code Security, Cloud Workload Protection (Agent, Agentless, Web Application and API Security) , Cloud Infrastructure Entitlement Management, Cloud Data Security, Cloud Security Posture Management . Demonstrates how the platform adds value to different persona's starting from developers to executives.
Uses Github actions for CI and CD process.
## Intent:
 Demo intent is to showcase Prisma Cloud Capabilities across
  - Multiple clouds. (EKS,GKE,AKS)
  - Multiple form factors. (Container, Host, Serverless, Google Run)
  - Different phases of application lifecycle.
  - Multiple teams.
## Installation:
 - Terraform templates are provided in IaC folder. These are for reference only. Please modify as per your requiremnts.
 - Yaml files for K8s deployment are provided in root folder
 - Github action files can be foind in .github folder and secrets configured can be found [here](https://github.com/chanduusc/prismacloud-demo#secrets)
## Code Security:
### Coding phase (Persona: Developer/Devops)
1. Install Checkov plugin for VSCode (or IntelliJ) 
2. Copy copy_to_req file to requirements.txt
3. The developer/devops will be notified of misconfigurations/vulnerabilites within IDE while coding.
![Check the vulnerabilities in IDE](checkov_plugin.png)
> Example files for terraform,yaml,secrets can be found in fake_commits folder. Please use as per your requirement.
# Work in progress

Needs the below secrets to be configured in your Github
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
| `AZURE_CREDENTIALS` | Service principal secrets JSON. Should be auto-populated by TF. | <pre>{<br>    "clientId": "61c9a3cd-000d-4a4d-963a-f28c7c050c02",<br/>    (...)<br/>}</pre> |
| `REGISTRY_LOGIN_SERVER` | ACR repo FQDN. Should be auto-populated by TF. | `pythonserver.azurecr.io` |
| `REGISTRY_USERNAME` | `clientId` value from `AZURE_CREDENTIALS`. Should be auto-populated by TF. | `61c9a3cd-000d-4a4d-963a-f28c7c050c02` |
| `REGISTRY_PASSWORD` | `clientSecret` value from `AZURE_CREDENTIALS`. Should be auto-populated by TF. | `abc123YB0MXBd9tOFRufFTbiQ1el.rF8S6_DvzuAJYQz2f` |
| `RESOURCE_GROUP` | Name od the RG containing EKS. Should be auto-populated by TF. | `pc-demo-rg` |
| `CLUSTER_NAME` | EKS cluster name. Should be auto-populated by TF. | `pc-demo-eks` |

### AWS
| Secret | Description | Example |
| --- | --- | --- |
| `AWS_ACCESS_KEY_ID` | AWS_ACCESS_KEY_ID for your IAM demo-user. | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` |AWS_SECRET_ACCESS_KEY for your IAM demo-user. | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_REGION` | The AWS region where ECR is located in. Should be auto-populated by TF. | `eu-central-1` |
| `AWS_EKS_NAME` | Name of the EKS cluster. Should be auto-populated by TF. | `pc-demo-eks` |
| `KUBE_CONFIG_DATA` | `cat $HOME/.kube/config \| base64`<br>Fallback if `AWS_EKS_NAME` is missing | `YmFzZTY0IG...V4YW1wbGU=` |
| `REPO_NAME` | The name of the ECR repository. Should be auto-populated by TF. | `pythonscript` |

### GCP
| Secret | Description | Example |
| --- | --- | --- |
| `GKE_SA_KEY` | Contents of credentials JSON file for the service account. Should be auto-populated by TF. | <pre>{<br/>  "type": "service_account",<br/>  (...)<br/>}</pre> |
| `GKE_PROJECT` | Name of the GCP project containing GKE (available in terraform outputs). Should be auto-populated by TF. | `pc-demo` |
| `GKE_CLUSTER` | Name of the GKE cluster (available in terraform outputs). Should be auto-populated by TF. | `pc-demo-gke` |
| `GKE_ZONE ` | Name of the GKE GCP zone (available in terraform outputs). Should be auto-populated by TF. | `europe-west4-c` | 
| `IMAGE` | Name of the docker image | `pythonserver` |



