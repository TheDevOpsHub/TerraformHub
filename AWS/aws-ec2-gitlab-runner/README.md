# AWS EC2 as GitLab runner

Provision and configure GitLab runner on EC2 intance

## Document

- https://gitlab.com/
- https://us-east-1.console.aws.amazon.com/ec2/
- To get Token: Gitlab > $YOUR_GROUP > $Your_Project > CI/CD Settings > Register runner
- https://docs.gitlab.com/runner/register/

## Provision step

### 0. Prepare

- A Gitlab account
- An AWS account
- Create a AWS key pair for EC2 intance: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html
  - Update your keyname to `variables.tf` file
- Terraform set up and configur, see: [docs/terraform-aws-setup](../docs/terraform-aws-setup.md)
- Create GitLab runner on UI: https://docs.gitlab.com/ee/tutorials/create_register_first_runner/#create-and-register-a-project-runner
- Get the token for later step:
  - Create `terraform.tfvars` file base on `terraform.tfvars.example` (`cp terraform.tfvars.example terraform.tfvars`)
  - Update your `gitlab_runner_registration_token ` to `terraform.tfvars` file

### 1. Initialize Terraform

```bash
cd aws-ec2-gitlab-runner
terraform init
```

### 2. Plan the Terraform Configuration

```bash
terraform plan -out "runner.tfplan.out"
```

### 3. Apply the Terraform Configuration

```bash
terraform apply "runner.tfplan.out"
```

### ⚠️ 4. Clean Up Resources

Once we do not need the Runner anymore, lets terminate it:

```bash
terraform destroy
```

## Architecture

Once provisioning proccess completed, we will have the GitLab-AWS EC2 architecture as this [flow](./flow.md)

## Debug

- Connect to EC2 instance

```bash
# Open an SSH client.
# Locate your private key file. The key used to launch this instance is 'ec2-ssh-key.pem'
# Run this command, if necessary, to ensure your key is not publicly viewable.

chmod 400 "ec2-ssh-key.pem"

# Connect to your instance using its Public DNS: yourec2domain.compute-1.amazonaws.com

ssh -i "ec2-ssh-key.pem" ec2-user@yourec2domain.compute-1.amazonaws.com

## NOTE: Repace 'ec2-ssh-key.pem' by your key name
```

- Debug gitlab runner service on EC2

```bash
systemctl status gitlab-runner.service
```
