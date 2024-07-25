# AWS EC2 as GitLab runner

## Info

- https://gitlab.com/
- https://us-east-1.console.aws.amazon.com/ec2/
- To get Token: Gitlab > $YOUR_GROUP > $Your_Project > CI/CD Settings > Register runner
- https://docs.gitlab.com/runner/register/

## Provision step

### 1. Initialize Terraform:

```bash
cd aws-ec2-gitlab-runner
terraform init
```

### 2. Plan the Terraform Configuration:

```bash
terraform plan -out "runner.tfplan.out"
```

### 3. Apply the Terraform Configuration:

```bash
terraform apply "runner.tfplan.out"
```

### ⚠️ 4. Clean Up Resources:

Once we do not need the Runner anymore, lets terminate it:

```bash
terraform destroy
```

## Architecture

Once provisioning proccess completed, we will have the GitLab-AWS EC2 architecture as below:

```plaintext
                                 +----------------------+
                                 |                      |
                                 |    GitLab Server     |
                                 |  (gitlab.com or self-|
                                 |   hosted instance)   |
                                 |                      |
                                 +----------------------+
                                             |
                                             | Registration
                                             | Token
                                             v
                                 +----------------------+
                                 |                      |
                                 |  AWS Infrastructure  |
                                 |                      |
                                 +----------------------+
                                             |
                                             | Terraform
                                             | Configuration
                                             v
       +--------------------------------------------+
       |                                            |
       |                AWS Region                  |
       |             (e.g., us-east-1)              |
       |                                            |
       +--------------------------------------------+
                                             |
                                             |
         +-------------------------------+   |
         |                               |   |
         |  VPC                          |   |
         |                               |   |
         | +---------------------------+ |   |
         | |                           | |   |
         | |  Security Group           | |   |
         | |  (gitlab-runner-sg)       | |   |
         | |   Ingress:                | |   |
         | |    - Port 22 (SSH)        | |   |
         | |      0.0.0.0/0            | |   |
         | |   Egress:                 | |   |
         | |    - All traffic          | |   |
         | |      0.0.0.0/0            | |   |
         | |                           | |   |
         | +---------------------------+ |   |
         |                               |   |
         |                               |   |
         | +---------------------------+ |   |
         | |                           | |   |
         | |  EC2 Instance             | |   |
         | |  (GitLab Runner)          | |   |
         | |   - AMI: Amazon Linux 2   | |   |
         | |   - Instance Type: t2.micro||   |
         | |   - Key Pair: your-key-pair||   |
         | |   - User Data:            | |   |
         | |     Install & Register    | |   |
         | |     GitLab Runner         | |   |
         | |                           | |   |
         | +---------------------------+ |   |
         |                               |   |
         +-------------------------------+   |
                                             |
                Outputs:                     |
                - Instance ID                |
                - Instance Public IP         |
                                             |
                                             v
                                 +----------------------+
                                 |                      |
                                 |  Administrator's     |
                                 |     Workstation      |
                                 |                      |
                                 +----------------------+
                                             |
                                             | SSH Access
                                             v
```

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
