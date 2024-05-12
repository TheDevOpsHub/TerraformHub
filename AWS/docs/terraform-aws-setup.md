## Terraform AWS Setup

To setup AWS with Terraform you will need:

- The Terraform CLI (1.2.0+) installed.
- The AWS CLI installed.
- AWS account and associated credentials that allow you to create resources.

Get Started - AWS:

- https://developer.hashicorp.com/terraform/tutorials/aws-get-started

To use your IAM credentials to authenticate the Terraform AWS provider, set the AWS credentials environment variable:

- This will be available in terminal session only:

```bash
export AWS_ACCESS_KEY_ID=xxxx-xxxx-xxxx # Replace by yours
export AWS_SECRET_ACCESS_KEY=yyyy-yyyy-yyyy # Replace by yours
```

To set the AWS credentials permanently, use `aws configure`:

```bash
aws configure

## Then input your AWS information:
# AWS Access Key ID [****************53GT]:
# AWS Secret Access Key [****************IGNx]:
# Default region name [us-east-1]:
# Default output format [None]:
```
