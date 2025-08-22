## Generic variable
# variable "aws_id" {
#   description = "AWS account ID"
#   type = string
# }

variable "resource_tags" {
  description = "Default resource tags"
  type        = map(string)
}

# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = ""
}

# Business Division
variable "owners" {
  description = "organization this Infrastructure belongs"
  type        = string
  default     = ""
}

## EC2 variable
# EC2 AMI
variable "ami-id" {
  description = "EC2 AMI"
  type        = string
  default     = ""
}

# EC2 root size
variable "root_size" {
  type = number
}

## VPC variables
# VPC IP mask
variable "cidr_mask" {
  type = string
}

# VPC Availability Zones
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}


## RDS variables
# RDS instance class
variable "rds_instance_class" {
  type    = string
  default = ""
}

# RDS backup retention period
variable "rds_backup_retention_period" {
  type    = number
  default = "7"
}

# RDS engine
variable "rds_engine" {
  type = string
}

