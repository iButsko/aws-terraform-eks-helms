
# create IAM role for EKS
resource "aws_iam_role" "devtest-eks_cluster_role" {
  name = "devtest-eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.devtest-eks_cluster_role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.devtest-eks_cluster_role.name
}

# Set up an IAM role for the worker nodes
resource "aws_iam_role" "devtest-workernodes" {
  name = "devtest-eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "ElasticLoadBalancingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonVPCFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AWSWAFFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSWAFFullAccess"
  role       = aws_iam_role.devtest-workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonRoute53FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  role       = aws_iam_role.devtest-workernodes.name
}

# creating the EKS cluster
resource "aws_eks_cluster" "devtest-eks_cluster" {
  name     = "devtest-eks-cluster"
  role_arn = aws_iam_role.devtest-eks_cluster_role.arn
  version  = "1.27" #EKS version

  vpc_config {
    subnet_ids              = [var.private_eks_subnet, var.private_eks_subnet2]
    endpoint_private_access = true # enable private access for endpoint's
    endpoint_public_access  = true
  }
  depends_on = [aws_iam_role.devtest-eks_cluster_role,
  ]
}

#creating the worker nodes
resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.devtest-eks_cluster.name
  node_group_name = "devtest-workernodes"
  node_role_arn   = aws_iam_role.devtest-workernodes.arn
  subnet_ids      = [var.private_eks_subnet, var.private_eks_subnet2]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}

data "aws_eks_cluster_auth" "devtest_cluster_token" {
  name = aws_eks_cluster.devtest-eks_cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.devtest-eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.devtest-eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.devtest_cluster_token.token
}

# resource "kubernetes_config_map" "aws-auth" {
#   data = {
#     "mapRoles" = <<EOT
# - groups:
#     - system:bootstrappers
#     - system:nodes
#   rolearn: arn:aws:iam::043751989667:role/devtest-eks-node-group
#   username: system:node:{{EC2PrivateDNSName}}
# - groups:
#     - system:masters
# - rolearn: arn:aws:iam::043751989667:role/devtest_gha_oidc_assume_role
#   username: devtest_gha_oidc_assume_role

# EOT
#   }

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }
# }