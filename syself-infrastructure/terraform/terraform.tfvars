args = {

  credentials = {
    access_key = ""
    secret_key = ""
  }
  lb_ami_id     = "ami-0aff18ec83b712f05"
  node_ami_id   = "ami-0b9727076a631e62c"
  instance_type = "t3.medium"
  cluster_name  = "syself-cluster"

  vpc_cidr    = "10.0.0.0/16"
  node_count  = 3
  environment = "prod"
}
