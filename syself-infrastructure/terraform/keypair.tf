resource "tls_private_key" "syself_privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "syself_publickey" {
  key_name   = "syself-key"
  public_key = tls_private_key.syself_privatekey.public_key_openssh
}

resource "local_file" "private_key_file" {
  filename        = "${path.module}/syself-key.pem"
  file_permission = "0400"

  content = tls_private_key.syself_privatekey.private_key_pem
}