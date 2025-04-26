variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "eks"
}

variable "environment" {
  description = "Environment (dev, test, prod, etc)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "example"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "terraform"
}

# Cluster configuration
variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

# Network configuration
variable "vpc_id" {
  description = "ID of the VPC for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster nodes"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "List of subnet IDs for the EKS control plane"
  type        = list(string)
  default     = null
}

# Managed node groups
variable "node_instance_types" {
  description = "List of instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the managed node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the managed node group"
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the managed node group"
  type        = number
  default     = 2
}

variable "node_group_capacity_type" {
  description = "Capacity type for the managed node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 50
}

variable "enable_node_ssh_access" {
  description = "Enable SSH access to worker nodes"
  type        = bool
  default     = false
}

variable "node_ssh_key_name" {
  description = "SSH key name for worker nodes"
  type        = string
  default     = null
}

variable "ssh_source_security_group_ids" {
  description = "List of security group IDs allowed to SSH to worker nodes"
  type        = list(string)
  default     = []
}

variable "node_labels" {
  description = "Labels to apply to nodes in the managed node group"
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "Taints to apply to nodes in the managed node group"
  type        = list(map(string))
  default     = []
}

# Self-managed node groups
variable "create_self_managed_nodes" {
  description = "Create self-managed node groups"
  type        = bool
  default     = false
}

variable "self_managed_node_instance_type" {
  description = "Instance type for self-managed node groups"
  type        = string
  default     = "t3.medium"
}

variable "self_managed_node_min_size" {
  description = "Minimum number of nodes in the self-managed node group"
  type        = number
  default     = 1
}

variable "self_managed_node_max_size" {
  description = "Maximum number of nodes in the self-managed node group"
  type        = number
  default     = 3
}

variable "self_managed_node_desired_size" {
  description = "Desired number of nodes in the self-managed node group"
  type        = number
  default     = 2
}

variable "self_managed_use_spot_instances" {
  description = "Use spot instances for self-managed node groups"
  type        = bool
  default     = false
}

# Fargate
variable "create_fargate_profiles" {
  description = "Create Fargate profiles"
  type        = bool
  default     = false
}

# Auth
variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of AWS account IDs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "admin_trusted_role_arns" {
  description = "ARNs of IAM roles that can assume the EKS admin role"
  type        = list(string)
  default     = []
}

# Route53/External DNS
variable "route53_zone_arns" {
  description = "List of Route53 zone ARNs for External DNS"
  type        = list(string)
  default     = ["*"]
}

# Logging
variable "enable_cluster_logging" {
  description = "Enable EKS control plane logging to CloudWatch"
  type        = bool
  default     = false
}

variable "cluster_log_retention_days" {
  description = "Number of days to retain EKS cluster logs"
  type        = number
  default     = 90
}
