resource "aws_s3_bucket" "k8s-sala-backup" {
  bucket = "k8s-sala-backup"

  tags = {
    Name        = "k8s-salaserver-velero-backup"
  }
}
