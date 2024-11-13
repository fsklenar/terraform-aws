module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-sg"
  description = "Security group for Postgres"
  vpc_id      = module.vpc_main.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Postgres"
      cidr_blocks = module.vpc_main.vpc_cidr_block
    }
  ]
}
