resource "aws_s3_bucket" "s3_data_import" {
  bucket = "${local.name}"
}
