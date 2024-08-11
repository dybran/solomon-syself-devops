resource "local_file" "output_yaml" {
  content = yamlencode({
    "ENVIRONMENT"     = var.args.environment,
    "MASTER1_IP"      = aws_instance.syself_master_nodes[0].private_ip,
    "MASTER2_IP"      = aws_instance.syself_master_nodes[1].private_ip,
    "MASTER3_IP"      = aws_instance.syself_master_nodes[2].private_ip,
    "WORKER1_IP"      = aws_instance.syself_worker_nodes[0].private_ip,
    "WORKER2_IP"      = aws_instance.syself_worker_nodes[1].private_ip,
    "WORKER3_IP"      = aws_instance.syself_worker_nodes[2].private_ip,
    "BASTION_IP"      = aws_instance.syself_bastion.public_ip,
    "LOADBALANCER_IP" = aws_instance.syself_haproxy.public_ip,
    "VPC_ID"          = aws_vpc.syself_vpc.id
  })
  filename = "${path.module}/syself-cluster-ips.yaml"
}