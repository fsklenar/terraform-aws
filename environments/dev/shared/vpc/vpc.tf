module "vpc_main" {
  source = "../../../../modules/vpc" # Replace with the actual path to your module directory

  vpcname   = "vpc-${local.name}" # Overriding the name defined in variable file
  cidr_mask = var.cidr_mask

  azs = var.azs

  tags = {
    owners = var.owners
  }
  vpc_tags = {
    owners = var.owners
  }
  create_database_subnet_group = true
  enable_nat_gateway           = false
  single_nat_gateway           = false

}
