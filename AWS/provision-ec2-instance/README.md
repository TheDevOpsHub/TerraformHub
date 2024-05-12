# Provision and setup AWS EC2 instance

## Description

This demo will:

- Use the terraform S3 backend deployed from [tf-backend](../tf-backend/)
- Provision an EC2 intance
- Get the SSH private key from `terraform output` and save to `~/.ssh/...` to access the EC2 via SSH in the next step
- SSH to the newly provisioned EC2 instance and run `remote` script to setup neccessary tool on the remote EC2 machine

## Deploy

Run

```bash
cd scripts
./provision_n_setup_ec2.sh
```

## Cleanup

Run

```bash
cd scripts
./cleanup_vm.sh
```
