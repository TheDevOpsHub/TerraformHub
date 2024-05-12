terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    # Replace this with your S3 bucket name!
    bucket = "tungleo-terraform-state-s3"
    key    = "aws/ec2-demo-terraform.tfstate"
    region = "us-east-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}


resource "aws_instance" "agent_scaler" {
  # Check AMi at: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
  ami             = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.focalboard_sg_scaler.name]
  key_name        = aws_key_pair.kp_scaler.key_name

  tags = {
    Name = "Azure-Agent-Scaler"
  }
}

# Security Group
resource "aws_security_group" "focalboard_sg_scaler" {
  name        = "focalboard-security-group-scaler"
  description = "Focalboard security group allowing ports 22 and 80"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# SSH keys
resource "tls_private_key" "pk_scaler" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp_scaler" {
  key_name   = "myDemoKey" # Create "myKey" to AWS!!
  public_key = tls_private_key.pk_scaler.public_key_openssh

  provisioner "local-exec" { # Create "myAWSKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk_scaler.private_key_pem}' > /tmp/myDemoKey.pem"
  }
}


output "private_key" {
  value     = tls_private_key.pk_scaler.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = aws_instance.agent_scaler.public_ip
}
