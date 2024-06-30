## Prerequisites

- [Setup Terraform to work with Azure](../docs/terraform-azure-setup.md)

## Prepare SSH key

In order to SSH to the new VM as well as deploy the service, you need to provide your SSH key

```bash
cp secret.tfvars.template secret.tfvars

# Now add your SSH public key to secret.tfvars (DO NOT commit it!!!)
```

## Provision with Terraform CLI

```bash
# navigate to terraform code
cd TerraformHub/Azure/create-vm-with-service

# init
terraform init -upgrade

# plan
terraform plan -out main.tfplan -var-file="secret.tfvars"

# apply
terraform apply main.tfplan
```

## Check the result

```bash
resource_group_name=$(terraform output -raw resource_group_name)
echo "resource_group_name:"
echo "$resource_group_name"
echo "VM list:"
az vm list --resource-group $resource_group_name --query "[].{\"VM Name\":name}" -o table
```

Or go to Azure Portal to view your resource https://portal.azure.com/#browse/resourcegroups

## Cleanup

If you are done with the experimental and want to stop/destroy all the resources, run:

```bash
terraform plan -destroy -out main.destroy.tfplan
```

## Ref

- https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables#set-values-with-a-tfvars-file

## Troubleshooting?

- [troubleshooting.md](../docs/troubleshooting.md)
