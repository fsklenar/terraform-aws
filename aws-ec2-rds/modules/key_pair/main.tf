#module "key_pair" {

  resource "aws_key_pair" "ec2_key" {
    key_name   = var.key_pair_name
    public_key = tls_private_key.rsa-4096-ec2.public_key_openssh
  }

  # RSA key of size 4096 bits
  resource "tls_private_key" "rsa-4096-ec2" {
    algorithm = "RSA"
    rsa_bits  = 4096
  }

  resource "local_file" "tf_key" {
    sensitive_content  = tls_private_key.rsa-4096-ec2.private_key_pem
    filename = pathexpand(var.key_file_name)
    file_permission = "600"
    directory_permission = "700"
  }

#}
