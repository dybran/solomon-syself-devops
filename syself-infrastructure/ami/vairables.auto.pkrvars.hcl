args = {
  access_key = "AKIA5VVRKDMLXOUZYO7I"
  secret_key = "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"

  region          = "us-west-2"
  ami_name_prefix = "syself"
  instance_type   = "t3.medium"
  ami             = "ami-0aff18ec83b712f05"
  ssh_username    = "ubuntu"
  tags = {
    Environment = "Production"
    Project     = "syself_task"
  }
}