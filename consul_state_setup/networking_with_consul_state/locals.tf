locals {
  cidr_block = jsondecode(data.consul_keys.networking.var.networking)["cidr_block"]
  private_subnets = jsondecode(data.consul_keys.networking.var.networking)["private_subnets"]
  public_subnets = jsondecode(data.consul_keys.networking.var.networking)["public_subnets"]
  subnet_count = jsondecode(data.consul_keys.networking.var.networking)["subnet_count"]
}

