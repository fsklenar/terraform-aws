## Generic variable
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


