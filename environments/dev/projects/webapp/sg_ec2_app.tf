module "ec2_app_sg" {
  source = "terraform-aws-modules/security-group/aws"



  name        = "ec2-app-sg"
  description = "Security group for EC2 APP"
  vpc_id      = data.terraform_remote_state.vpc_main.outputs.vpc_id
  tags = {
    purpose = "APP"
  }

  ingress_cidr_blocks = [data.terraform_remote_state.vpc_main.outputs.vpc_cidr_block]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = join("", [module.ec2-jump.private_ip, "/32"])
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http"
      cidr_blocks = data.terraform_remote_state.vpc_main.outputs.vpc_cidr_block
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
