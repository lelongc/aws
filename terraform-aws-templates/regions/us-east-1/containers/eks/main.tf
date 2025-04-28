provider "aws" {
  region = var.region
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "cluster" {
  name = "${var.project}-${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Attach required policies to the cluster role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "node_group" {
  name = "${var.project}-${var.environment}-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# Attach required policies to the node group role
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

# Create CloudWatch Log Group for EKS Cluster
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.project}-${var.environment}/cluster"
  retention_in_days = var.log_retention_days
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.project}-${var.environment}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version
  
  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }
  
  enabled_cluster_log_types = var.enabled_cluster_log_types
  
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn
    }
  }
  
  tags = {
    Name        = "${var.project}-${var.environment}-cluster"
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "this" {
  count = length(var.node_groups)
  
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project}-${var.environment}-${var.node_groups[count.index].name}"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.node_groups[count.index].subnet_ids != null ? var.node_groups[count.index].subnet_ids : var.subnet_ids
  
  ami_type        = var.node_groups[count.index].ami_type
  capacity_type   = var.node_groups[count.index].capacity_type
  instance_types  = var.node_groups[count.index].instance_types
  disk_size       = var.node_groups[count.index].disk_size
  
  scaling_config {
    desired_size = var.node_groups[count.index].desired_size
    max_size     = var.node_groups[count.index].max_size
    min_size     = var.node_groups[count.index].min_size
  }
  
  update_config {
    max_unavailable = var.node_groups[count.index].max_unavailable
  }
  
  labels = merge(
    {
      "role" = var.node_groups[count.index].name
    },
    var.node_groups[count.index].labels
  )
  
  tags = merge(
    {
      Name        = "${var.project}-${var.environment}-${var.node_groups[count.index].name}"
      Environment = var.environment
      Project     = var.project
      Terraform   = "true"
    },
    var.node_groups[count.index].tags
  )
  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

# AWS Auth ConfigMap
# Note: This is done for demonstration. In real-world scenarios, use Kubernetes provider or manage with external tools
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
  addon_version = var.coredns_version
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
  addon_version = var.kube_proxy_version
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
  addon_version = var.vpc_cni_version
}
