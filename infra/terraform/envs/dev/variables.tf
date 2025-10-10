variable "bastion_key_name" {
  description = "Name of an existing EC2 key pair for Bastion"
  type        = string
  default     = "virginia-key-pair" # <--- KEY PAIR NAME HERE
}