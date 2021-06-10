module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  name = "example-primary"
  cidr = local.cidr_block
  azs = slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
  private_subnets = local.private_subnets
  public_subnets = local.public_subnets

  enable_nat_gateway = false
  create_database_subnet_group = false

  tags = {
    Environment = "Production"
    Team = "Network"
  }
}
