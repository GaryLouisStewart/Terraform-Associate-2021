locals {
  cidr_block = jsondecode(data.consul_keys.networking.var.networking)["cidr_block"]
  subnet_count = jsondecode(data.consul_keys.networking.var.networking)["subnet_count"]
  common_tags = jsondecode(data.consul_keys.networking.var.common_tags)
}

