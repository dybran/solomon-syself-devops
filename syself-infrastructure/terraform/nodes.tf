resource "aws_instance" "syself_master_nodes" {
  count = var.args.node_count

  subnet_id = aws_subnet.syself_priv_subs[count.index].id

  vpc_security_group_ids = [
    aws_security_group.syself_node_sg.id
  ]

  ami           = var.args.node_ami_id
  instance_type = var.args.instance_type
  root_block_device {
    volume_size = 25
  }

  key_name = aws_key_pair.syself_publickey.key_name


  tags = {
    format("kubernetes.io/cluster/%v", var.args.cluster_name) = "owned"
    "node-type"                                               = "master"
    Name                                                      = "syself-master-${count.index + 1}"
  }
}

resource "aws_instance" "syself_worker_nodes" {
  count = var.args.node_count

  subnet_id = aws_subnet.syself_priv_subs[count.index].id

  vpc_security_group_ids = [
    aws_security_group.syself_node_sg.id
  ]

  ami           = var.args.node_ami_id
  instance_type = var.args.instance_type
  root_block_device {
    volume_size = 25
  }

  key_name = aws_key_pair.syself_publickey.key_name

  tags = {
    format("kubernetes.io/cluster/%v", var.args.cluster_name) = "owned"
    "node-type"                                               = "worker"
    Name                                                      = "syself-worker-${count.index + 1}"
  }
}

