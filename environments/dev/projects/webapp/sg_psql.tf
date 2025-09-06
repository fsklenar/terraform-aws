module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-sg"
  description = "Security group for Postgres"
  vpc_id      = data.terraform_remote_state.vpc_main.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Postgres"
      cidr_blocks = data.terraform_remote_state.vpc_main.outputs.vpc_cidr_block
    }
  ]
}
