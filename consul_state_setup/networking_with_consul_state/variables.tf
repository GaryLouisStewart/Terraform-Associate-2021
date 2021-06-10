variable "region" {
  type = string
  default = "eu-west-2"
}

variable "consul_address" {
  type = string
  description = "Address of the consul server"
  default = "127.0.0.1"
}

variable "consul_port" {
  type = number
  description = "the port that the consul server is listening on"
  default = "8500"
}

variable "consul_datacenter" {
  type = string
  description = "Name of the consul datacenter"
  default = "dc1"
}
