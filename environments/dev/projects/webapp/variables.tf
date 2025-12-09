##EC2 variables
variable "root_size" {
  type = number
  description = "Size of root partition"
}

variable "ebs_size" {
  type = number
  description = "Size of EBS"
}

## RDS variables
variable "rds_storage" {
  type = number
  description = "Default RDS storage size in GB"  
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type = string
}

variable "rds_engine" {
  description = "RDS engine version"
  type = string
}

variable "db_prefix" {
  description = "Database name prefix"
  type = string
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period in days"
  type = number
}

