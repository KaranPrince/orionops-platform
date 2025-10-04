# 1. IAM Role and Instance Profile for the Bastion Host
# This role grants the EC2 instance permission to use AWS services.
resource "aws_iam_role" "bastion_role" {
  name = "orionops-bastion-role-dev"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
    }],
  })
}

resource "aws_iam_policy_attachment" "bastion_ssm_policy_attach" {
  # Add this for flexibility; you can still use SSM if PuTTY fails.
  name       = "bastion-ssm-policy-attach"
  roles      = [aws_iam_role.bastion_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" 
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "orionops-bastion-profile-dev"
  role = aws_iam_role.bastion_role.name
}

# 2. Security Group for the Bastion Host
resource "aws_security_group" "bastion" {
  name   = "orionops-bastion-sg-dev"
  # FIX: Use var.vpc_id, as it is passed into this module
  vpc_id = var.vpc_id 

  # Ingress: Allow SSH (Port 22) ONLY from your public IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # FIX: Use var.allowed_ssh_cidr, as it is passed into this module
    cidr_blocks = [var.allowed_ssh_cidr] 
    description = "Allow SSH from known IP"
  }


  # Egress: Allow all outbound connections (required to reach EKS nodes)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. EC2 Instance (Bastion Host)
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  # FIX: Use var.instance_type, as it is passed into this module
  instance_type               = var.instance_type
  # FIX: Use var.public_subnet_id, as it is passed into this module
  subnet_id                   = var.public_subnet_id 
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  # FIX: Use var.key_pair_name, as it is passed into this module
  key_name                    = var.key_pair_name 
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  tags = merge(var.tags, {
    Name = var.name_prefix
  })
}

# 4. Data Source to find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

# # 5. Output the Bastion IP for PuTTY
# output "bastion_public_ip" {
#   value = aws_instance.bastion.public_ip
# }