# Local Values in Terraform
locals {
  project       = "webapp"
  name          = "${var.owners}-${var.env}-${local.project}"
  key_file_name = "~/.ssh/id-rsa-${local.name}-ec2.key"

  resource_tags = {
    project     = "${local.project}",
  }

}
