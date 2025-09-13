
# EC2 Import Public IP
output "public_ip_import" {
  description = "EC2 IMPORT public IP"
  value       = module.ec2-import.public_ip
}

# EC2 instance ID
output "instance_id_import" {
  description = "EC2 IMPORT instance ID"
  value       = module.ec2-import.ec2_id
}

# EC2 private IP JUMP
output "private_ip_import" {
  description = "EC2 IMPORT private IP"
  value       = module.ec2-import.private_ip
}
