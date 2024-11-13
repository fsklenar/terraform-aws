# aws
Terraform code for AWS:
- EC2 - SSH jumphost + proxy
- EC2 - application server with EBS
- PostgreSQL
- including
  - VPC
  - security groups
  - subnet groups
- common VPC/EC2 and KeyPair modules used for different environments
- very easy to deploy for different environments - just change `locals.tf` and `terraform.tfvars`
