resource "aws_security_group" "gitlab_runner" {
  name        = "gitlab-runner-sg"
  description = "Security group for GitLab Runner"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "gitlab_runner" {
  # Check all available us-east-1 AMIs at: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
  ami             = "ami-03972092c42e8c0ca" # Amazon Linux 2 AMI
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.gitlab_runner.name]

  user_data = templatefile("install_runner.tpl", {
    gitlab_runner_registration_token = var.gitlab_runner_registration_token
  })

  tags = {
    Name = "AWS EC2 GitLab Runner"
  }
}
