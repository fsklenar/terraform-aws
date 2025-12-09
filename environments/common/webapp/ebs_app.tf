resource "aws_ebs_volume" "ec2-app" {
  availability_zone = data.terraform_remote_state.vpc_main.outputs.azs[0]
  size              = var.ebs_size
  type              = "gp3"
  encrypted         = false
  final_snapshot    = true

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_volume_attachment" "ec2-app" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ec2-app.id
  instance_id = module.ec2-app.ec2_id
}
