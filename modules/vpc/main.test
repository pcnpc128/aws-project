# VPC 생성
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true      # DNS 해석 활성화
  enable_dns_hostnames = true      # 퍼블릭 IP에 DNS 이름 부여
  tags = {
    Name = "${var.name}-vpc"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true   # EC2 인스턴스에 퍼블릭 IP 자동 할당
  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false  # 퍼블릭 IP는 할당하지 않음
  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-igw"
  }
}

# 퍼블릭 서브넷용 라우팅 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # 외부 인터넷(0.0.0.0/0) 트래픽은 인터넷 게이트웨이로 라우팅
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

# 라우팅 테이블과 퍼블릭 서브넷 연결
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

