# Create the RDS Instance
resource "aws_db_instance" "psql" {
  allocated_storage = local.rds_storage
  engine            = "postgres"
  engine_version    = var.rds_engine
  instance_class    = var.rds_instance_class
  identifier        = "rds-${local.name}-db"
  username          = "postgres"
  manage_master_user_password = true
  db_name                     = "flexdb"
  skip_final_snapshot         = false
  db_subnet_group_name        = module.vpc_main.database_subnet_group_name
  delete_automated_backups    = false
  backup_retention_period     = var.rds_backup_retention_period
  final_snapshot_identifier   = "flexdb-snapshot-final"

  # Security Group Configuration (Optional)
  vpc_security_group_ids = [
    module.db_sg.security_group_id
  ]
}
