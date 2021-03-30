resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${var.environment}-igw"})
}


resource "aws_subnet" "public" {
  count                   = length(var.sn_addr_space)
  cidr_block              = var.sn_addr_space[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.common_tags, { Name = "${var.environment}-sn-${count.index}"})
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${var.environment}-rtb"})

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-sn1" {
  count = length(var.sn_addr_space)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

