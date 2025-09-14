# Local Values in Terraform
locals {
  project       = "webapp"
  name          = "${var.owners}-${var.env}-${local.project}"
  ebs_size      = 5
  rds_storage   = 20
  key_file_name = "~/.ssh/id-rsa-${local.name}-ec2.key"

  # EC2 Variables
  ami-id    = "ami-0a116fa7c861dd5f9"
  root_size = "12"

  #RDS
  rds_instance_class          = "db.t4g.micro"
  rds_backup_retention_period = 3
  rds_engine                  = "17"
  db_prefix                   = "flexdb"

  resource_tags = {
    project     = "${local.project}",
  }

}
