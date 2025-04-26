output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_oidc_issuer_url" {
  description = "URL of the OIDC Provider for the EKS cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

# Managed node groups
output "eks_managed_node_groups" {
  description = "Map of EKS managed node group attributes"
  value       = module.eks.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

# Self-managed node groups
output "self_managed_node_groups" {
  description = "Map of self-managed node group attributes"
  value       = module.eks.self_managed_node_groups
}

output "self_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by self-managed node groups"
  value       = module.eks.self_managed_node_groups_autoscaling_group_names
}

# Fargate profiles
output "fargate_profiles" {
  description = "Map of Fargate Profile attributes"
  value       = module.eks.fargate_profiles
}

# Service accounts IAM roles
output "cluster_autoscaler_iam_role_arn" {
  description = "ARN of the Cluster Autoscaler IAM role"
  value       = module.cluster_autoscaler_irsa.iam_role_arn
}

output "aws_load_balancer_controller_iam_role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM role"
  value       = module.aws_load_balancer_controller_irsa.iam_role_arn
}

output "external_dns_iam_role_arn" {
  description = "ARN of the External DNS IAM role"
  value       = module.external_dns_irsa.iam_role_arn
}

output "eks_admin_iam_role_arn" {
  description = "ARN of the EKS admin IAM role"
  value       = module.eks_admin_iam.iam_role_arn
}

# Kubectl command for updating kubeconfig
output "kubectl_config_command" {
  description = "Command to update the kubeconfig file with the new cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
