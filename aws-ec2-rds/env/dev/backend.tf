terraform {
  backend "s3" {
    bucket = "terraform-050752630539-state"
    key    = "aws01"
    region = "eu-central-1"
  }
}

