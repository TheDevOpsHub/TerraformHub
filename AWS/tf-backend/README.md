# Create AWS E3/DynamoDB backend

## Prepare

Checkout code:

```bash
git clone https://github.com/TheDevOpsHub/TerraformHub.git
```

Update the S3 and DynamoDB naming variable:

- Open [TerraformHub/AWS/tf-backend/variables.tf](./variables.tf) file then change `bucket_name` and `table_name` to your own value

```terraform
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "your-bucker-name"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "your-table-name"
}
```

## Deploy

Run:

```bash
cd scripts
./create-backend.
```

## Cleanup

Run:

```bash
cd scripts
./destroy-backend.sh
```
