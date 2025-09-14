###VPC variable
# VPC variables defined as below
# VPC Name
variable "vpcname" {
  description = "VPC Name"
  type        = string
  default     = "vpc"
}

# VPC CIDR Block
variable "cidr_mask" {
  description = "VPC CIDR Block"
  type        = string
}

# VPC Availability Zones
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

# VPC Create Database Subnet Group (True / False)
variable "create_database_subnet_group" {
  description = "VPC Create Database Subnet Group, Controls if database subnet group should be created"
  type        = bool
  default     = true
}

# VPC Enable NAT Gateway (True or False)
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

# VPC Single NAT Gateway (True or False)
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "tags" {
  type = map
}

variable "vpc_tags" {
  type = map
  #default = {}
}




