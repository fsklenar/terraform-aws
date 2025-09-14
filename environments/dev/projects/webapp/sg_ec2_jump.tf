module "ec2_jump_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2-jump-sg"
  description = "Security group for EC2 JUMP"
  vpc_id      = data.terraform_remote_state.vpc_main.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

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
