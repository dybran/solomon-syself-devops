resource "aws_instance" "syself_bastion" {
  subnet_id = aws_subnet.syself_pub_sub.id

  vpc_security_group_ids = [
    aws_security_group.syself_bastion_sg.id
  ]

  ami           = var.args.node_ami_id
  instance_type = var.args.instance_type
  root_block_device {
    volume_size = 25
  }

  key_name = aws_key_pair.syself_publickey.key_name

  provisioner "file" {
    when       = create
    on_failure = fail

    connection {
      host = aws_instance.syself_bastion.public_ip

      user        = "ubuntu"
      private_key = tls_private_key.syself_privatekey.private_key_pem
    }

    content     = tls_private_key.syself_privatekey.private_key_pem
    destination = "/home/ubuntu/syself-key.pem"
  }

  tags = {
    Name = "syself-bastion"
  }

}

