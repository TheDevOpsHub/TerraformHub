#!/bin/bash

## Navigate back to Terraform folder
cd ..

# Init
terraform init -upgrade

# Plan
terraform plan -out main.tfplan

# Apply
terraform apply main.tfplan

# Check
terraform output -raw public_ip
