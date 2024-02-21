# LocalStack Terraform IAC

## Requirements

- Docker with compose
- Terraform/OpenTofu

## How to use 


```bash
git clone https://github.com/kduchagaslima/localstack-terraform.git
cd localstack-terraform
docker compose up
```

> **Note:** This step whill provide localstack container and a sftp server

```bash
cd localstack-terraform/terraform
terraform init
terraform plan
terraform apply --auto-approve
```

## Additional resources

```bash
cd localstack-terraform/terraform/done
```

In this directory there is some testes resources like **sqs**, **batch**, **lambda** , etc...

So, move these files to previous directory and apply with **terraform**.
