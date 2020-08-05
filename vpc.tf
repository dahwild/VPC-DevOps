# Declare the Availability Zones data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "DevOps-VPC-TF"
  }
}

# Subnets
resource "aws_subnet" "main-public-1" {
  #count                   = length(data.aws_availability_zones.available.names)
  count  = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  #cidr_block              = var.public_subnet_cidr[0]
  #cidr_block              = length(var.public_subnet_cidr)
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  #availability_zone       = "us-east-1a"

  tags = {
    Name = "DevOps-vpc-public-tf"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id = aws_vpc.main.id
  count  = length(var.private_subnet_cidr)
  #cidr_block = element(var.private_subnet_cidr, count.index)
  #cidr_block              = length(var.private_subnet_cidr)
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = "false"
  #availability_zone       = "us-east-1a"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "DevOps-vpc-private-tf"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "DevOps-igw-tf"
  }
}

# Nat GW
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
  subnet_id = aws_subnet.main-public-1[0].id
  #subnet_id     = aws_subnet.main-public-1.id
  allocation_id = aws_eip.nat.id
  depends_on    = [aws_internet_gateway.main-gw]
  tags = {
    Name = "DevOps-ngw-tf"
  }
}


# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "DevOps-rt-igw-tf"
  }
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "DevOps-rt-natgw-tf"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  count = length(var.public_subnet_cidr)
  # subnet_id      = aws_subnet.main-public-1.id
  #count = length(aws_subnet.main-public-1.id)
  #subnet_id      = aws_subnet.main-public-1.*.id
  subnet_id      = element(aws_subnet.main-public-1.*.id, count.index)
  route_table_id = aws_route_table.main-public.id
}

# route associations private
resource "aws_route_table_association" "main-private-1-a" {
  count = length(var.private_subnet_cidr)
  #subnet_id      = aws_subnet.main-private-1.id
  subnet_id      = element(aws_subnet.main-private-1.*.id, count.index)
  route_table_id = aws_route_table.main-private.id
}
