#!/bin/sh

cd /tf-files
# chmod 777 -R /app/code/pkg
echo "Initializing Terraform"
terraform init
echo "Validating Terraform"
terraform plan -out=planned-deploy.tfplan

echo "Applying Terraform"
terraform apply planned-deploy.tfplan