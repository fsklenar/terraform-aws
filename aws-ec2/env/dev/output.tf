# VPC Private Subnets
output "private_subnets" {
  description = "A list of private subnets inside the VPC"
  value       = module.vpc_main.private_subnets
}

# VPC Public Subnets
output "public_subnets" {
  description = "A list of public subnets inside the VPC"
  value       = module.vpc_main.public_subnets
}

# VPC Database Subnets
output "database_subnets" {
  description = "A list of database subnets inside the VPC"
  value       = module.vpc_main.database_subnets
}

# EC2 Jump Public IP
output "public_ip_jump" {
  description = "EC2 JUMP public IP"
  value       = module.ec2-jump.public_ip
}

# VPC AZs
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc_main.azs
}

# EC2 instance ID
output "instance_id_jump" {
  description = "EC2 JUMP instance ID"
  value       = module.ec2-jump.ec2_id
}

# EC2 instance ID
output "instance_id_app" {
  description = "EC2 APP instance ID"
  value       = module.ec2-app.ec2_id
}

# EC2 private IP JUMP
output "private_ip_jump" {
  description = "EC2 JUMP private IP"
  value       = module.ec2-jump.private_ip
}

# EC2 private IP APP
output "private_ip_app" {
  description = "EC2 APP private IP"
  value       = module.ec2-app.private_ip
}

# RDS instance endpoint
output "rds_instance_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.psql.endpoint
}

# Secrets manager
output "secret_name" {
  description = "Secrets manager secret name"
  value       = aws_db_instance.psql.master_user_secret
}
