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
# VPC IP mask
variable "cidr_mask" {
  type = string
}

# # VPC Availability Zones
# variable "azs" {
#   description = "A list of availability zones names or ids in the region"
#   type        = list(string)
# }

# Allowed IP for SSH access
variable "whitelist-ssh-ip" {
  description = "Allowed IP for SSH access"
  default = "37.139.8.159/32"
}
#
# variable "script_path" {
#   type    = string
#   default = "N/A"
# }
