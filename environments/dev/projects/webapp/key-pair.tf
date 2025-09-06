module "key-pair-ec2" {
  source = "../../../../modules/key_pair"

  key_pair_name = "ec2_key"
  key_file_name = local.key_file_name
}
