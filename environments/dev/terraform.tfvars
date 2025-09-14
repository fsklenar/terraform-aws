# # Generic Variables
aws_id = "050752630539"
region = "eu-central-1"
owners = "iptiq"
env = "dev"

# # VPC Variables
cidr_mask = "240"
azs       = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

resource_tags = {
  environment = "{$var.env}"
}

