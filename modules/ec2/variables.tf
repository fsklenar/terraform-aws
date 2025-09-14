# EC2
# AWS Region
variable "ec2-instance-type" {
  description = "EC2 instance typr"
  type        = string
  default     = ""
}

# EC2 Name
variable "ec2-name" {
  description = "EC2 Name"
  type        = string
  default     = "ec2"
}

# EC2 AMI
variable "ec2-ami" {
  description = "EC2 AMI"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "security_group_id" {
  description = "ID of existing security group whose rules we will manage"
  type        = string
  default     = null
}

variable "root_size" {
  type = number
  default = 8
}

variable "create_eip" {
  type = bool
  default = false
}

variable "associate_public_ip_address" {
  type = bool
  default = false
}

# variable "resource_tags" {
#   description = "Default resource tags"
#   type        = map(string)
# }
