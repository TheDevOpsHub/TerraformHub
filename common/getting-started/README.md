As a DevOps engineers, our daily routine often revolves around deploying and managing infrastructure. Mastering the features and functionalities Terraform offers is one of the best investments you can make in yourself as a DevOps.

In this post we will go through the Terraform introduction, concepts, then get hands on by building, changing, destroying the AWS EC2 instance.
If you think I've overlooked something or should delve deeper into a particular topic, please leave a comment below. I'll update this post accordingly. Thanks in advance!

Now let’s get started 🔥🔥🔥

---

## What is Terraform?

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision a datacenter infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

---

## Key Concepts

Understanding the core concepts of Terraform is crucial to effectively managing infrastructure. Here are the foundational elements:

- **Providers**: Providers are responsible for understanding API interactions and exposing resources. AWS, Azure, and Google Cloud are all examples of providers.

- **Resources**: Resources are the most important element in the Terraform language. Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records.

- **Modules**: Modules are containers for multiple resources that are used together. They are the primary way to package and reuse resource configurations.

- **State**: Terraform state is used to map real-world resources to your configuration, keep track of metadata, and improve performance for large infrastructures. The state is stored in a `.tfstate` file.

- **Provisioners**: Provisioners are used to execute scripts on a local or remote machine as part of the resource creation or destruction.

- **Data Sources**: Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

---

## Installing Terraform

- Check this document: https://developer.hashicorp.com/terraform/install to install terraform on your machine.

---

## Terraform with AWS Setup

In this guide we will demonstrate the integration between Terraform and AWS infrastructure, to setup AWS with Terraform you will need:

- The Terraform CLI (1.2.0+) installed.
- The AWS CLI installed (https://aws.amazon.com/cli/).
- AWS account and associated credentials that allow you to create resources (https://aws.amazon.com/console/).

To use your IAM credentials to authenticate the Terraform AWS provider, to set the AWS credentials permanently, use `aws configure`:

```bash
aws configure

## Then input your AWS information:
# AWS Access Key ID [****************53GT]:
# AWS Secret Access Key [****************IGNx]:
# Default region name [us-east-1]:
# Default output format [None]:

## Check your credential by running:
aws configure list

## Output
# ➜  ~ aws configure list
#       Name                    Value             Type    Location
#       ----                    -----             ----    --------
#    profile                <not set>             None    None
# access_key     ****************53GT shared-credentials-file
# secret_key     ****************IGNx shared-credentials-file
#     region                us-east-1      config-file    ~/.aws/config
```

---

## Your First Terraform Configuration

Create a new directory for your project and navigate into it:

```bash
mkdir terraform-aws-demo
cd terraform-aws-demo
```

Create a file named `main.tf` and open it in your favorite text editor. This file will contain your Terraform configuration.

Here’s a simple configuration to create an EC2 Ubuntu 22.04 instance on AWS:

```tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami             = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform Demo"
  }
}
```

Check all available AMI in `us-east-1` region at: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
<br>NOTE: You could find the terraform code in this blog post [here](https://github.com/TheDevOpsHub/TerraformHub/tree/main/common/getting-started)

---

## Initializing Terraform

Before Terraform can perform any operations, it needs to be initialized. This is done by running:

```bash
terraform init

## Sample output:
# Initializing the backend...
# Initializing provider plugins...
# - Finding latest version of hashicorp/aws...
# - Installing hashicorp/aws v5.58.0...
# - Installed hashicorp/aws v5.58.0 (signed by HashiCorp)
# ...
# Terraform has been successfully initialized!
```

This command downloads the necessary provider plugins and prepares your environment.

---

## Creating the Infrastructure

To see what Terraform will do before actually applying changes, run:

```bash
terraform plan
```

If everything looks good, apply the changes:

```bash
terraform apply

## Sample output:
# Enter a value: yes
# aws_instance.example: Creating...
# aws_instance.example: Still creating... [10s elapsed]
# aws_instance.example: Still creating... [20s elapsed]
# aws_instance.example: Still creating... [30s elapsed]
# aws_instance.example: Creation complete after 38s [id=i-099dc08ae004bb7f7]

# Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Terraform will prompt you to confirm. Type `yes` to proceed. Terraform will now provision the resources defined in your configuration.
<br>Now visit [AWS EC2 Console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) you can see your `Terraform Demo` instance up and running:
![ec2](https://github.com/TheDevOpsHub/TerraformHub/blob/main/common/getting-started/asset/ec2-ok.png?raw=true)

---

## Inspecting the State

Terraform's state is stored in a file named terraform.tfstate. You can inspect the current state by running:

```bash
terraform show

## Output
# aws_instance.example:
# resource "aws_instance" "example" {
#     ami                                  = "ami-0e001c9271cf7f3b9"
#     arn                                  = "arn:aws:ec2:us-east-1:992382371456:instance/i-099dc08ae004bb7f7"
#     associate_public_ip_address          = true
#     availability_zone                    = "us-east-1b"
#     cpu_core_count                       = 1
#     ...
#     host_id                              = null
#     iam_instance_profile                 = null
#     id                                   = "i-099dc08ae004bb7f7"
#     instance_initiated_shutdown_behavior = "stop"
#     instance_lifecycle                   = null
#     instance_state                       = "running"
#     instance_type                        = "t2.micro"
# ...other information
```

This command displays all the infrastructure managed by Terraform.

---

## Modifying Infrastructure

To make changes to your infrastructure, modify the main.tf file. For example, you can modify the tags associated with the EC2 instance:

```terraform
resource "aws_instance" "example" {
  ami           = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04
  instance_type = "t2.micro"

  tags = {
    Name = "Updated Terraform Demo" # Update instance tag name
    Environment = "Development" # Adding new tag
  }
}
```

---

## Initializing Changes

After modifying your configuration, initialize Terraform again to update its state and refresh dependencies:

```bash
terraform init
```

---

## Applying Changes

After initializing, you can apply your changes to update the infrastructure:

```bash
terraform apply

## Sample output
# aws_instance.example: Refreshing state... [id=i-099dc08ae004bb7f7]

# Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
#   ~ update in-place

# Terraform will perform the following actions:
#   # aws_instance.example will be updated in-place
#   ~ resource "aws_instance" "example" {
#         id                                   = "i-099dc08ae004bb7f7"
#       ~ tags                                 = {
#           + "Environment" = "Development"
#           ~ "Name"        = "Terraform Demo" -> "Updated Terraform Demo"
#         }
#       ~ tags_all                             = {
#           + "Environment" = "Development"
#           ~ "Name"        = "Terraform Demo" -> "Updated Terraform Demo"
#         }
#         # (38 unchanged attributes hidden)
#         # (8 unchanged blocks hidden)
#     }

```

Confirm by typing `yes` when prompted. Terraform will then update the tags for the existing EC2 instance to reflect your changes.
<br>Visit [AWS EC2 Console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) you can see your instance name is changed to `Updated Terraform Demo`:
![ec2-updated](https://github.com/TheDevOpsHub/TerraformHub/blob/main/common/getting-started/asset/ec2-updated.png?raw=true)

---

## Using Variables and Outputs

Variables in Terraform allow you to parameterize your configurations. They can make your configurations more dynamic and reusable. Here's an example of using variables:

Create a `variables.tf` file:

```tf
variable "instance_name" {
  description = "Name of the EC2 instance"
  default     = "Variable Terraform Demo"
}
variable "environment" {
  description = "Name of the environment"
  default     = "development"
}
```

Modify main.tf to use the variable:

```tf
resource "aws_instance" "example" {
  ami           = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
    Environment = var.environment
  }
}
```

In this example, `instance_name` is a variable that defaults to "Variable Terraform Demo". You can override this value when running terraform apply.

Outputs in Terraform allow you to extract and display information about your infrastructure. Add an `outputs.tf` file:

```tf
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

```

Apply your configuration by runnint `terraform apply`:

```bash
terraform apply
## Sample output
# aws_instance.example: Modifying... [id=i-099dc08ae004bb7f7]
# aws_instance.example: Modifications complete after 7s [id=i-099dc08ae004bb7f7]

# Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

# Outputs:

# instance_id = "i-099dc08ae004bb7f7"
# instance_public_ip = "44.202.163.210"
```

Now you can view the output by running:

```bash
# Get Instance ID
terraform output instance_id
## i-099dc08ae004bb7f7

# Get Public IP
terraform output instance_public_ip
## "x.x.x.x"
```

---

## Destroying Infrastructure

To tear down the infrastructure managed by Terraform, you can run:

```bash
terraform destroy
```

Confirm by typing `yes` when prompted. Terraform will then proceed to destroy all resources defined in your configuration.

---

## Best Practices

Here are some best practices to follow when working with Terraform:

- Use Version Control: Always keep your Terraform configuration files in version control (e.g., Git).
- Use Remote State: Store your state file remotely to collaborate with others and avoid potential issues with local state files.
- Modularize: Use modules to organize your configuration into reusable components.
- Backup State Files: Regularly back up your state files to prevent data loss.
- Use Variables and Outputs: Use variables to make your configuration flexible and outputs to expose information about your infrastructure.

---

## Common Commands Cheat Sheet

- `terraform init` - Initialize a Terraform configuration
- `terraform plan` - Show changes required by the current configuration
- `terraform apply` - Apply the changes required by the current configuration
- `terraform destroy` - Destroy the Terraform-managed infrastructure
- `terraform fmt` - Reformat your configuration in the standard style
- `terraform validate` - Validate the configuration files in a directory
- `terraform state` - Advanced state management
- `terraform output` - Show output values from a state file

---

## Useful Resources

Here are some tools and resources to help you along your Terraform journey:

- [terraform/docs](https://developer.hashicorp.com/terraform/docs)
- [Awesome Terraform](https://github.com/shuaibiyy/awesome-tf)
- [Terraform Hub](https://github.com/TheDevOpsHub/TerraformHub)
- Book: `Terraform: Up and Running`

---

## Summary

In this post, we introduced the fundamentals of Terraform, covering key concepts like providers, resources, and modules. We demonstrated installing Terraform, creating a basic EC2 instance on AWS, and performing essential operations like initializing, applying, modifying, and destroying infrastructure. Additionally, we highlighted best practices and basic usage of variables and outputs to enhance your Terraform configurations.
<br>I hope this help you for the Terraform journey. Thank you for reading and happy coding! 💖
