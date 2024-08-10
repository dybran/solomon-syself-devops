resource "aws_subnet" "syself_priv_subs" {
  count = length(local.availability_zones)

  vpc_id            = aws_vpc.syself_vpc.id
  availability_zone = local.availability_zones[count.index]
  cidr_block        = cidrsubnet(var.args.vpc_cidr, local.subnet_count, count.index)

  tags = {
    format("kubernetes.io/cluster/%v", var.args.cluster_name) = "shared"
  }

  depends_on = [aws_nat_gateway.syself_natgw]
}

resource "aws_route_table" "syself_priv_sub_rts" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.syself_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.syself_natgw.id
  }
}

resource "aws_route_table_association" "private_subnet_route_table_associations" {
  count = length(local.availability_zones)

  route_table_id = aws_route_table.syself_priv_sub_rts[count.index].id
  subnet_id      = aws_subnet.syself_priv_subs[count.index].id
}
