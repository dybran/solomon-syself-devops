
resource "aws_autoscaling_group" "syself_worker_asg" {
  name_prefix = "syself-worker-nodes"
  launch_template {
    id      = aws_launch_template.syself_worker_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [for private_subnet in aws_subnet.syself_priv_subs[*] : private_subnet.id]

  min_size         = var.args.worker_min_size
  max_size         = var.args.worker_max_size
  desired_capacity = var.args.worker_desired_capacity

  health_check_type = "EC2"

  tag {
    key                 = format("kubernetes.io/cluster/%v", var.args.cluster_name)
    value               = "1"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.args.cluster_name}-worker"
    propagate_at_launch = true
  }
}
