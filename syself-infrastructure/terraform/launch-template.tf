
resource "aws_launch_template" "syself_worker_template" {
  name_prefix = var.args.cluster_name

  image_id      = var.args.node_ami_id
  instance_type = var.args.instance_type

  key_name               = aws_key_pair.syself_publickey.key_name
  vpc_security_group_ids = [aws_security_group.syself_node_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      KubernetesCluster                                         = var.args.cluster_name
      format("kubernetes.io/cluster/%v", var.args.cluster_name) = "1"
      "node-type"                                               = "worker"
    }
  }

  tags = {
    Name = "syself-lt"
  }

}
