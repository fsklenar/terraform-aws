# Data source to read the shared VPC state
data "terraform_remote_state" "vpc_main" {
  backend = "s3"
  config = {
    bucket = "terraform-050752630539-state"
    key    = "dev/vpc"
    region = "eu-central-1"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-050752630539-state"
    key    = "dev/data-import"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.env
      Source      = replace(path.cwd, "/^.*?(${"terraform"}\\/)/", "$1")
    }
  }
}
