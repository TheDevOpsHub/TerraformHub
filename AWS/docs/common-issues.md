# Troubleshooting common issues

1. Error message: ConditionalCheckFailedException: The conditional request failed

- Try to unlock with:

```bash
terraform force-unlock -force LOCK_ID
```

2. Error: Backend initialization required: please run "terraform init"

- Try:

```bash
terraform init -reconfigure
```
