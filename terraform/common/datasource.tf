data "aws_vpc" "ma-personal-vpc" {
  id = "vpc-05cd37450a750b709"
}

data "aws_internet_gateway" "ma-personal-igw" {
  internet_gateway_id = "igw-06fda598abc1e4a21"
}

data "aws_eip" "ma_allocation_id" {
  id = "eipalloc-09693f87b0532f5de"
}
