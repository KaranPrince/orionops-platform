# envs/dev/outputs.tf

output "bastion_public_ip" {
  description = "The Public IP address for the Bastion Host"
  # CORRECTED: Must use the full output name "bastion_public_ip" from the module
  value = module.bastion.bastion_public_ip
}

# You should also check for and update the security group ID if you output it here:
# output "bastion_security_group_id" {
#   value = module.bastion.sg_id # Assuming you named the internal output 'sg_id'
# }