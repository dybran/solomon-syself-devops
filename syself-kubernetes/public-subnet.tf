resource "aws_subnet" "syself_pub_sub" {
  vpc_id     = aws_vpc.syself_vpc.id
  cidr_block = cidrsubnet(var.args.vpc_cidr, local.subnet_count, length(local.availability_zones))

  map_public_ip_on_launch = true
}

resource "aws_route_table" "syself_pub_sub_rt" {
  vpc_id = aws_vpc.syself_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.syself_ig.id
  }
}

resource "aws_route_table_association" "syself_pub_sub_rt_assoc" {
  route_table_id = aws_route_table.syself_pub_sub_rt.id
  subnet_id      = aws_subnet.syself_pub_sub.id
}
