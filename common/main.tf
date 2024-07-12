provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0e001c9271cf7f3b9" # Ubuntu 22.04
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform Demo"
  }
}
