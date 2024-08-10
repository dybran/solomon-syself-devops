resource "aws_instance" "syself_haproxy" {
  ami           = var.args.lb_ami_id
  instance_type = var.args.instance_type

  subnet_id = aws_subnet.syself_pub_sub.id

  vpc_security_group_ids = [
    aws_security_group.syself_node_sg.id
  ]

  key_name = aws_key_pair.syself_publickey.key_name

  user_data = templatefile("${path.module}/loadbalancer-script/haproxy-config.sh", {
    MASTER1_IP = aws_instance.syself_master_nodes[0].private_ip
    MASTER2_IP = aws_instance.syself_master_nodes[1].private_ip
    MASTER3_IP = aws_instance.syself_master_nodes[2].private_ip
  })

  tags = {
    Name = "syself-haproxy"
  }
}

