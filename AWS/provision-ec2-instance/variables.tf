## Variables
variable "agent_tag_name" {
  description = "The tag name of your EC2 instance"
  type        = string
  default     = "Demo-EC2"
}
variable "security_group_name_for_ec2" {
  description = "The tag name of your EC2 instance"
  type        = string
  default     = "New-Demo-SG-EC2"
}
variable "ssh_key_name_for_ec2" {
  description = "SSH Key name"
  type        = string
  default     = "ssh-Key-EC2"
}
