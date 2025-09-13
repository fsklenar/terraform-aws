# Generic Variables
#aws_id = "050752630539"
region = "eu-central-1"
owners = "project01"
project = "data-import"
env = "dev"

# VPC Variables
cidr_mask = "240"
azs       = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

# EC2 Variables
ami-id    = "ami-0a116fa7c861dd5f9"
root_size = "12"

resource_tags = {
  project     = "data-import",
  environment = "dev"
}
