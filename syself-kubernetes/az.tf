# Fetch available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Pick the first 3 available availability zones
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)

  # Define the number of subnets (3 private + 1 public subnet)
  subnet_count = length(local.availability_zones) + 1
}

