## Generic variable
variable "aws_id" {
  description = "AWS account ID"
  type = string
}

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
#  default     = ""
}

# Environment
variable "env" {
  description = "Environment/stage"
  type        = string
  default     = ""
}

## VPC variables
variable "cidr_mask" {
  type = string
  description = "VPC IP mask"
}

# Allowed IP for SSH access
variable "whitelist-ssh-ip" {
  description = "Allowed IP for SSH access"
  default = "37.139.8.159/32"
}


