#!/bin/bash
set -e

# Connect
## Navigate back to Terraform folder
cd ..
LINUX_USER="ubuntu"
private_key_data_file_name="demo_ec2_key"

# Setup filename and get public IP
public_ip_addr=$(terraform output -raw public_ip)
echo "public_ip_addr: $public_ip_addr"

## Cleanup old file
sudo rm -rf ~/.ssh/${private_key_data_file_name} || true
touch ~/.ssh/${private_key_data_file_name} || true

echo "Getting private key"
terraform output -raw private_key >~/.ssh/${private_key_data_file_name}
chmod 400 ~/.ssh/${private_key_data_file_name}
ls -la

# Connect and check
ssh -o StrictHostKeyChecking=no -i ~/.ssh/${private_key_data_file_name} $LINUX_USER@${public_ip_addr} 'ls -la'

# Connect and setup
cd scripts

# Install tooling
echo "Install tooling on agent"
ssh -o StrictHostKeyChecking=no -i ~/.ssh/${private_key_data_file_name} $LINUX_USER@${public_ip_addr} 'bash -s' <./remote/remote_install_tools.sh

# Add SSH instruction
echo "Setup completed!"
echo
echo "SSH Key location"
echo "~/.ssh/${private_key_data_file_name}"
echo
echo "Now you can run following command to SSH to the EC2 instance:"
echo "ssh -o StrictHostKeyChecking=no -i ~/.ssh/${private_key_data_file_name} $LINUX_USER@${public_ip_addr}"
