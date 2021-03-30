resource "aws_vpc" "vpc" {
  cidr_block = var.network_addr_space
  enable_dns_hostnames = "true"

  tags = merge(local.common_tags, { Name = "${var.environment}-vpc"})
}