provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  name        = var.name
  environment = var.environment
  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
  
  cluster_name    = "${local.name}-${local.environment}"
  cluster_version = var.cluster_version
  
  # Map of OIDC providers to use in IAM roles for service accounts
  eks_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    default_node_group = {
      name = "node-group-1"

      instance_types = var.node_instance_types
      
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      capacity_type  = var.node_group_capacity_type
      disk_size      = var.node_disk_size
      
      # Use Launch Template
      use_custom_launch_template = true
      
      # Remote access (SSH) to nodes
      remote_access = var.enable_node_ssh_access ? {
        ec2_ssh_key               = var.node_ssh_key_name
        source_security_group_ids = var.ssh_source_security_group_ids
      } : null

      labels = var.node_labels

      taints = var.node_taints

      update_config = {
        max_unavailable_percentage = 25
      }

      tags = local.tags
    }
  }

  # Self Managed Node Group(s)
  self_managed_node_groups = var.create_self_managed_nodes ? {
    self_managed_group = {
      name = "self-managed-nodes"
      
      instance_type = var.self_managed_node_instance_type
      
      min_size     = var.self_managed_node_min_size
      max_size     = var.self_managed_node_max_size
      desired_size = var.self_managed_node_desired_size
      
      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
      
      use_mixed_instances_policy = var.self_managed_use_spot_instances
      mixed_instances_policy = var.self_managed_use_spot_instances ? {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 0
          spot_allocation_strategy                 = "capacity-optimized"
        }
      } : null

      post_bootstrap_user_data = <<-EOT
        echo "You can run additional bootstrap scripts here"
      EOT
      
      tags = local.tags
    }
  } : {}

  # Fargate Profile(s)
  fargate_profiles = var.create_fargate_profiles ? {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        },
        {
          namespace = "kube-system"
        }
      ]
      tags = local.tags
    }
  } : {}

  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles = concat(
    var.aws_auth_roles,
    [
      {
        rolearn  = module.eks_admin_iam.iam_role_arn
        username = "eks-admin"
        groups   = ["system:masters"]
      }
    ]
  )
  
  aws_auth_users = var.aws_auth_users
  aws_auth_accounts = var.aws_auth_accounts

  # Tags
  tags = local.tags
}

# IAM role for EKS admin
module "eks_admin_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  role_name         = "${local.cluster_name}-admin-role"
  create_role       = true
  role_requires_mfa = false

  trusted_role_arns = var.admin_trusted_role_arns

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  ]

  tags = local.tags
}

# IAM role with OIDC for Cluster Autoscaler
module "cluster_autoscaler_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                        = "${local.cluster_name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_id]

  oidc_providers = {
    main = {
      provider_arn               = local.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  tags = local.tags
}

# IAM role with OIDC for AWS Load Balancer Controller
module "aws_load_balancer_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "${local.cluster_name}-aws-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = local.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = local.tags
}

# IAM role with OIDC for External DNS
module "external_dns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                     = "${local.cluster_name}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.route53_zone_arns

  oidc_providers = {
    main = {
      provider_arn               = local.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }

  tags = local.tags
}

# Create CloudWatch log group for control plane logs if enabled
resource "aws_cloudwatch_log_group" "eks_cluster" {
  count = var.enable_cluster_logging ? 1 : 0
  
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_days
  
  tags = local.tags
}
