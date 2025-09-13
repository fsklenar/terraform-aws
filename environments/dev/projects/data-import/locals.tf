# Local Values in Terraform
locals {
  name          = "${var.owners}-${var.project}-${var.env}"
  ebs_size      = 5
  key_file_name = "~/.ssh/id_rsa_${var.project}-ec2.key"
}
