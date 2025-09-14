terraform {
  backend "s3" {
    bucket = "terraform-050752630539-state"
    key    = "dev/vpc"
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
