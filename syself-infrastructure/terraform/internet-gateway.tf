resource "aws_internet_gateway" "syself_ig" {
  vpc_id = aws_vpc.syself_vpc.id
  tags = {
    Name = "syself-ig"
  }
}
