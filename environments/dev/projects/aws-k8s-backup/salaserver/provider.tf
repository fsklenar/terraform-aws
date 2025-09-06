# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Terraform   = "true"
      Source      = replace(path.cwd, "/^.*?(${"terraform"}\\/)/", "$1")
    }
  }
}

terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}





