## Terraform Azure Setup

To setup Terraform to work with Azure you will need:

- Install Terraform: https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli
- Install Azure CLI: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
- Login with Azure CLI to get credentials and create service principal:

```bash
# 1. Authenticate using the Azure CLI
az login --use-device-code

# To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code xxxxxxxx to authenticate.
# 2. Get the subscription ID from the output (<SUBSCRIPTION_ID>), then run
az account set --subscription "<SUBSCRIPTION_ID>"

# 3. Create Service Principal
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

# Creating 'Contributor' role assignment under scope '/subscriptions/35akss-subscription-id'
# The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
# {
#   "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
#   "displayName": "azure-cli-2022-xxxx",
#   "password": "xxxxxx~xxxxxx~xxxxx",
#   "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
# }

# 4. Set your environment variables
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<tenant>"
```

- Ref: https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build
