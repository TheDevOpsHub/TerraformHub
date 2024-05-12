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
