variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "private_key_path" {
  type = string
}
variable "region" {
  default = "eu-west-2"
}

variable "network_addr_space" {
  default = "10.2.0.0/16"
}

variable "sn1_addr_space" {
  default = "10.2.0.0/24"
}

variable "sn2_addr_space" {
  default = "10.2.1.0/24"
}


resource "aws_vpc" "vpc" {
  cidr_block = var.network_addr_space
  enable_dns_hostnames = "true"
}