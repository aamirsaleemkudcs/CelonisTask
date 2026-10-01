# ----------------------------------
# VPC
# ----------------------------------

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# ----------------------------------
# Public Subnet
# ----------------------------------

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-public-subnet"
    Environment              = var.environment
    Type                     = "Public"
    "kubernetes.io/role/elb" = "1"
  }
}

# ----------------------------------
# Private Subnet
# ----------------------------------

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.project_name}-private-subnet"
    Environment                       = var.environment
    Type                              = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ----------------------------------
# Internet Gateway
# ----------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# ----------------------------------
# Public Route Table
# ----------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# ----------------------------------
# Public Internet Route
# ----------------------------------

resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# ----------------------------------
# Associate Public Subnet
# ----------------------------------

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ----------------------------------
# Private Route Table
# ----------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-private-rt"
    Environment = var.environment
  }
}

# ----------------------------------
# Associate Private Subnet
# ----------------------------------

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# ----------------------------------
# Private Subnet 2
# ----------------------------------

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id

  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_2

  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.project_name}-private-subnet-2"
    Environment                       = var.environment
    Type                              = "Private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# ==========================================
# Isolated Database Subnet A
# ==========================================

resource "aws_subnet" "database_1" {
  vpc_id = aws_vpc.main.id

  cidr_block        = var.database_subnet_1_cidr
  availability_zone = var.availability_zone

  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-database-subnet-1"
    Environment = var.environment
    Type        = "Database-Isolated"
  }
}

# ==========================================
# Isolated Database Subnet B
# ==========================================

resource "aws_subnet" "database_2" {
  vpc_id = aws_vpc.main.id

  cidr_block        = var.database_subnet_2_cidr
  availability_zone = var.availability_zone_2

  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-database-subnet-2"
    Environment = var.environment
    Type        = "Database-Isolated"
  }
}

# ==========================================
# Database Route Table
# No Internet Gateway
# No NAT Gateway
# ==========================================

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-database-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "database_1" {
  subnet_id      = aws_subnet.database_1.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_2" {
  subnet_id      = aws_subnet.database_2.id
  route_table_id = aws_route_table.database.id
}

# ==========================================
# Elastic IP for NAT Gateway
# ==========================================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip"
    Environment = var.environment
  }
}

# ==========================================
# NAT Gateway
# ==========================================

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name        = "${var.project_name}-nat-gateway"
    Environment = var.environment
  }
}

# ==========================================
# Private Route -> NAT Gateway
# ==========================================

resource "aws_route" "private_internet" {
  route_table_id = aws_route_table.private.id

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}