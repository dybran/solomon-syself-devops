# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "syself_natgw_eip" {
  vpc = true
}

# Create the NAT Gateway
resource "aws_nat_gateway" "syself_natgw" {
  allocation_id = aws_eip.syself_natgw_eip.id
  subnet_id     = aws_subnet.syself_pub_sub.id

  tags = {
    Name = "syself-natgw"
  }
}
