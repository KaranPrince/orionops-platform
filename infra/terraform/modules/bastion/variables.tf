variable "vpc_id" {}
variable "subnet_id" {}
variable "key_name" {}
variable "instance_type" {}
variable "project" {}
variable "environment" {}
variable "common_tags" {
  type = map(string)
}
