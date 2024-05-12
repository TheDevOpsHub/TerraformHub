#!/bin/bash

# Ensure to create the s3/dynamoDB backend first
## Run: ../../tf-backend/create-backend.sh

# Provision a fresh AZ VM
./terraform_deploy_vm.sh

# Connect to VM and setup agent
./connect_and_setup.sh

# To destroy, run ./cleanup_vm.sh
