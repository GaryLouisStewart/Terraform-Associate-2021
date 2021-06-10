data "aws_availability_zones" "available" {}

data "consul_keys" "networking" {
  key {
    name = "networking"
    path = "networking/configuration/example-primary/net_info"
  }

  key {
    name = "common_tags"
    path = "networking/configuration/example-primary/common_tags"
  }
}



