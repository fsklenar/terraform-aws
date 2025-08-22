terraform {
  backend "s3" {
    bucket = "terraform-050752630539-state"
    key    = "dev/vpc"
    region = "eu-central-1"
  }
}

