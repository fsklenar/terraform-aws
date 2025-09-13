module "ec2_import_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2-${var.project}-sg"
  description = "Security group for EC2 IMPORT APP"
  vpc_id      = data.terraform_remote_state.vpc_main.outputs.vpc_id
  tags = {
    purpose = "IMPORT"
  }

  ingress_cidr_blocks = [data.terraform_remote_state.vpc_main.outputs.vpc_cidr_block]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "37.139.8.159/32"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
