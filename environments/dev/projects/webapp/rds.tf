# Create the RDS Instance
resource "aws_db_instance" "psql" {
  allocated_storage           = local.rds_storage
  engine                      = "postgres"
  engine_version              = local.rds_engine
  instance_class              = local.rds_instance_class
  identifier                  = "rds-${var.aws_id}-${local.name}-db"
  username                    = "postgres"
  manage_master_user_password = true
  db_name                     = "${local.db_prefix}"
  skip_final_snapshot         = false
  db_subnet_group_name        = data.terraform_remote_state.vpc_main.outputs.database_subnet_group_name
  delete_automated_backups    = false
  backup_retention_period     = local.rds_backup_retention_period
  final_snapshot_identifier   = "${local.db_prefix}-${local.name}-snapshot-final"

  # Security Group Configuration (Optional)
  vpc_security_group_ids = [
    module.rds_pg_sg.security_group_id
  ]
}
