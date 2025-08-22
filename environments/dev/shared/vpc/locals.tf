# Local Values in Terraform
locals {
  name          = "${var.owners}-${var.resource_tags.environment}"
}
