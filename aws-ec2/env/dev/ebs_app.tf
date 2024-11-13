resource "aws_ebs_volume" "ec2-app" {
  availability_zone = module.vpc_main.azs[0]
  size              = local.ebs_size
  type              = "gp3"
  encrypted         = false
  final_snapshot    = true

  tags = {
    Name = "EBS volume for ec2-app"
  }
}

resource "aws_volume_attachment" "ec2-app" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ec2-app.id
  instance_id = module.ec2-app.ec2_id
}
