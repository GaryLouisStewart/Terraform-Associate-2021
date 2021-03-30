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

variable"sn_addr_space" {
  default = ["10.2.0.0/24", "10.2.1.0/24"]
}

variable "environment" {
  default = "Dev"
}

variable "service" {
  default = "terraform-example-vpc-2"
}

variable "instance_count" {
  default = 2
}
