args = {

  credentials = {
    access_key = "AKIA5VVRKDMLXOUZYO7I"
    secret_key = "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"
  }
  lb_ami_id     = "ami-0aff18ec83b712f05"
  node_ami_id   = "ami-0b9727076a631e62c"
  instance_type = "t3.medium"
  cluster_name  = "syself-cluster"

  vpc_cidr    = "10.0.0.0/16"
  node_count  = 3
  environment = "prod"
}
