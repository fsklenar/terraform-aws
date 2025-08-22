terraform {
  backend "s3" {
    bucket = "terraform-050752630539-state"
    key    = "aws-k8s-backup"
    region = "eu-central-1"
  }
}

