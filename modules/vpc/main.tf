# Create VPC using Terraform Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # Details
  name            = var.vpcname
  cidr            = "10.${var.cidr_mask}.0.0/16"
  azs             = var.azs

  public_subnets   = ["10.${var.cidr_mask}.100.0/24", "10.${var.cidr_mask}.101.0/24", "10.${var.cidr_mask}.102.0/24"]
  private_subnets  = ["10.${var.cidr_mask}.10.0/24", "10.${var.cidr_mask}.11.0/24", "10.${var.cidr_mask}.12.0/24"]
  database_subnets = ["10.${var.cidr_mask}.110.0/24", "10.${var.cidr_mask}.111.0/24", "10.${var.cidr_mask}.112.0/24"]

  create_database_subnet_group           = var.create_database_subnet_group
  create_database_subnet_route_table     = var.create_database_subnet_group
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  # DNS Parameters in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Additional tags for the VPC
  tags     = var.tags
  vpc_tags = var.vpc_tags

  # Additional tags
  # Additional tags for the public subnets
  public_subnet_tags = {
    Name = "VPC Public Subnets"
  }
  # Additional tags for the private subnets
  private_subnet_tags = {
    Name = "VPC Private Subnets"
  }
  # Additional tags for the database subnets
  database_subnet_tags = {
    Name = "VPC Private Database Subnets"
  }
  # Instances launched into the Public subnet should be assigned a public IP address. Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  map_public_ip_on_launch = false

}





