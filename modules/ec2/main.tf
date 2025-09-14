#
# resource "null_resource" "folder_path" {
#   provisioner "local-exec" {
#     command = "echo \"folder_path=$(pwd)\" > path.tfvars"
#   }
# }

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  #folder_path_tag = file("path.tfvars")
  #root_module_path = path.module

  name = var.ec2-name

  instance_type          = var.ec2-instance-type
  ami                    = var.ec2-ami
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  create_eip = var.create_eip
  associate_public_ip_address = var.associate_public_ip_address
  key_name = var.key_pair_name

  root_block_device = {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.root_size
      enable_volume_tags = true
      volume_tags = var.volume_tags
  }

#   tags = var.resource_tags

}
