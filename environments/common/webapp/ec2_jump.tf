module "ec2-jump" {
  source = "../../../../modules/ec2"

  ec2-name = "${local.name}-jump"

  ec2-instance-type           = "t2.micro"
  #ec2-ami                     = local.ami-id
  ec2-ami                     = data.aws_ami.ubuntu.id
  subnet_id                   = data.terraform_remote_state.vpc_main.outputs.public_subnets[0]
  security_group_id           = module.ec2_jump_sg.security_group_id
  key_pair_name               = module.key-pair-ec2.key_pair_name
  root_size                   = var.root_size
  create_eip                  = true
  associate_public_ip_address = true
}

