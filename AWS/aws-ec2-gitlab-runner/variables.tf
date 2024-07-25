variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the instance."
  type        = string
  default     = "myKeyScaler" # change to yours
}

variable "gitlab_runner_registration_token" {
  description = "The GitLab Runner registration token."
  type        = string
  sensitive   = true
}
