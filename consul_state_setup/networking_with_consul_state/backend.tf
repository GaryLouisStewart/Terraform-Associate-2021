terraform {
  backend "consul" {
    address = "127.0.0.1:8500"
    scheme = "http"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "consul" {
  address = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}

provider "aws" {
  region = var.region
}
