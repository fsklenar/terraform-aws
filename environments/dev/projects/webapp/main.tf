# Data source to read the shared VPC state
data "terraform_remote_state" "vpc_main" {
  backend = "s3"
  config = {
    bucket = "terraform-050752630539-state"
    key    = "dev/vpc"
    region = "eu-central-1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

terraform {
  backend "s3" {
    bucket = "terraform-050752630539-state"
    key    = "dev/webapp"
    region = "eu-central-1"
  }
}


