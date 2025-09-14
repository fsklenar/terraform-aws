
# EC2 Public IP
output "public_ip_ec2" {
  description = "EC2 public IP"
  value       = module.ec2-data-import.public_ip
}

# EC2 instance ID
output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2-data-import.ec2_id
}

# EC2 private IP APP
output "private_ip_ec2" {
  description = "EC2 private IP"
  value       = module.ec2-data-import.private_ip
}
