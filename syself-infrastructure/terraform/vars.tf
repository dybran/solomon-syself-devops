variable "args" {
  type = object({

    credentials = object({
      access_key = string
      secret_key = string
    })
    lb_ami_id     = string
    node_ami_id   = string
    instance_type = string
    cluster_name  = string

    vpc_cidr    = string
    node_count  = number
    environment = string
  })
}
