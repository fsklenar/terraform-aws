# VPC ID
output "ec2_id" {
  description = "The ID of the VPC"
  value       = module.ec2.id
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value = module.ec2.public_ip
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value = module.ec2.private_ip
}

# output "path_output" {
#   value = var.folder_path_tag
# }
