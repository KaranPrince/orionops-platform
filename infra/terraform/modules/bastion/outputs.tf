# modules/bastion/outputs.tf

output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "sg_id" {
  description = "The ID of the Bastion Security Group"
  # CORRECTED: Referencing the actual resource name used in main.tf
  value       = aws_security_group.bastion.id 
}