variable "name_prefix"      { 
    type = string 
    }
variable "vpc_id"           { 
    type = string 
    }
variable "public_subnet_id" { 
    type = string 
    }
variable "region"           { 
    type = string
    default = "us-east-1" 
 }
variable "allowed_ssh_cidr" { 
    type = string
    default = "0.0.0.0/0" 
 }
variable "key_pair_name"    { 
    type = string
    default = "virginia-key-pair" 
     }
variable "instance_type"    { 
    type = string
    default = "t3.micro" 
 }
variable "tags"             { 
    type = map(string)
    default = {} 
    }
