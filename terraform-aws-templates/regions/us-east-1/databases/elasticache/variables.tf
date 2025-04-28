variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "create_cluster" {
  description = "Whether to create ElastiCache cluster"
  type        = bool
  default     = true
}

variable "engine" {
  description = "Cache engine: redis or memcached"
  type        = string
  default     = "redis"
}

variable "cluster_mode_enabled" {
  description = "Whether to enable cluster mode (sharding) for Redis"
  type        = bool
  default     = false
}

variable "node_type" {
  description = "Instance class to be used"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "parameter_group_family" {
  description = "ElastiCache parameter group family"
  type        = string
  default     = "redis7"
}

variable "engine_version" {
  description = "Version of the cache engine"
  type        = string
  default     = "7.0"
}

variable "port" {
  description = "Port number"
  type        = number
  default     = 6379
}

variable "subnet_group_name" {
  description = "Subnet group name to use (or will create one if empty)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache subnet group"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
  default     = ""
}

variable "create_security_group" {
  description = "Whether to create a security group for ElastiCache"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the cluster"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to connect to the cluster"
  type        = list(string)
  default     = []
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "snapshot_window" {
  description = "Time when ElastiCache takes a snapshot"
  type        = string
  default     = "03:00-05:00"
}

variable "snapshot_retention_limit" {
  description = "Number of days to retain snapshots"
  type        = number
  default     = 7
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade minor versions"
  type        = bool
  default     = true
}

variable "parameters" {
  description = "Map of ElastiCache parameters to apply"
  type        = map(string)
  default     = {}
}

variable "replication_group_id" {
  description = "ID of an external replication group to use (if not created)"
  type        = string
  default     = ""
}

variable "automatic_failover_enabled" {
  description = "Whether to enable automatic failover for Redis"
  type        = bool
  default     = true
}

variable "multi_az_enabled" {
  description = "Whether to enable Multi-AZ support"
  type        = bool
  default     = true
}

variable "replicas_per_node_group" {
  description = "Number of replicas per node group"
  type        = number
  default     = 1
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for Redis cluster mode"
  type        = number
  default     = 1
}
