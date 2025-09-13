module "key-pair-ec2" {
  source = "../../../../modules/key_pair"

  key_pair_name = "ec2_${var.project}"
  key_file_name = local.key_file_name
}
