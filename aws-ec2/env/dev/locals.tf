# Local Values in Terraform
locals {
  name          = "${var.owners}-${var.resource_tags.environment}"
  ebs_size      = 5
  rds_storage   = 20
  key_file_name = "~/.ssh/id_rsa_${var.owners}-ec2.key"

}
