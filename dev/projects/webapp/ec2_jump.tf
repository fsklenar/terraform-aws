module "ec2-jump" {
  source = "../../modules/ec2"

  ec2-name = "ec2-${local.name}-jump"

  ec2-instance-type           = "t2.micro"
  ec2-ami                     = var.ami-id
  subnet_id                   = module.vpc_main.public_subnets[0]
  security_group_id           = module.ec2_jump_sg.security_group_id
  key_pair_name               = module.key-pair-ec2.key_pair_name
  root_size                   = var.root_size
  create_eip                  = true
  associate_public_ip_address = true
}

