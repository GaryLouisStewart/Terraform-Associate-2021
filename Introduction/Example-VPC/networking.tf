resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}


resource "aws_subnet" "sn1" {
  cidr_block              = var.sn1_addr_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "sn2" {
  cidr_block = var.sn2_addr_space
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-sn1" {
  subnet_id = aws_subnet.sn1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rta-sn2" {
  subnet_id = aws_subnet.sn2.id
  route_table_id = aws_route_table.rtb.id
}

