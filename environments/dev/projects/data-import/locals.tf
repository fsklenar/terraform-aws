# Local Values in Terraform
locals {
  project       = "data-import"
  name          = "${var.owners}-${var.env}-${local.project}"
  key_file_name = "~/.ssh/id-rsa-${local.name}-ec2.key"

  # EC2 Variables
  ami-id    = "ami-0a116fa7c861dd5f9"

  resource_tags = {
    project     = "${local.project}",
  }

}
