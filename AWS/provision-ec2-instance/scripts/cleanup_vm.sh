#!/bin/bash

## Navigate back to Terraform folder
cd ..

# Plan
terraform plan -destroy -out main.destroy.tfplan

# Destroy
terraform apply main.destroy.tfplan



