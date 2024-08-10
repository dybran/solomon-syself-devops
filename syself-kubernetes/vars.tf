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

    vpc_cidr                = string
    master_node_count       = number
    environment             = string
    worker_min_size         = number
    worker_max_size         = number
    worker_desired_capacity = number
  })
}
