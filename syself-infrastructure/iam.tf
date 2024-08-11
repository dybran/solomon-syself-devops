resource "aws_iam_openid_connect_provider" "cognito_oidc_provider" {
  url = "https://cognito-idp.{region}.amazonaws.com/{user_pool_id}"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "9e99a48a9960b14926bb7f5a342d8a341d5e0aa2"  # Obtain from the Cognito domain certificate
  ]
}


# IAM Policy
resource "aws_iam_policy" "ebs_csi_policy" {
  name        = "EBSCSIDriverPolicy"
  description = "Policy for EBS CSI Driver"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:AttachVolume",
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role
resource "aws_iam_role" "ebs_csi_role" {
  name = "EBSCSIRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.k8s_oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "oidc.example.com:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ebs_csi_attachment" {
  policy_arn = aws_iam_policy.ebs_csi_policy.arn
  role     = aws_iam_role.ebs_csi_role.name
}
