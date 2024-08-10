resource "aws_vpc" "syself_vpc" {
  cidr_block = var.args.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true
}
