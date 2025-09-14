module "ec2_data_import_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2-${local.project}-sg"
  description = "Security group for EC2 ${local.project}"
  vpc_id      = data.terraform_remote_state.vpc_main.outputs.vpc_id

  ingress_cidr_blocks = [data.terraform_remote_state.vpc_main.outputs.vpc_cidr_block]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "${var.whitelist-ssh-ip}"
    }
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
