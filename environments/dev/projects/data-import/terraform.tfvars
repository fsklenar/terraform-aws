# # Generic Variables
aws_id = "050752630539"
region = "eu-central-1"
owners = "iptiq"
env = "dev"

# # VPC Variables
cidr_mask = "240"
#azs       = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

# EC2 Variables
root_size     = "12"
ebs_size      = 5
 
# #RDS
# rds_instance_class          = "db.t4g.micro"
# rds_backup_retention_period = 3
# rds_engine                  = "17"
# db_prefix                   = "flexdb"
# rds_storage                 = 20

resource_tags = {
  environment = "{$var.env}"
}

