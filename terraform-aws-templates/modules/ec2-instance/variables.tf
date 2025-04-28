variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "private_ips" {
  description = "A list of private IP address to associate with the instances"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "The user data to provide when launching the instance (base64 encoded)"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Whether to recreate the instance when user_data changes"
  type        = bool
  default     = false
}

variable "root_volume_type" {
  description = "Type of root volume. Can be 'standard', 'gp2', 'gp3', 'io1'"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_iops" {
  description = "Amount of IOPS for the root volume"
  type        = number
  default     = null
}

variable "root_volume_throughput" {
  description = "Throughput for the root volume in MiB/s"
  type        = number
  default     = null
}

variable "root_volume_delete_on_termination" {
  description = "Whether the root volume should be destroyed on instance termination"
  type        = bool
  default     = true
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_kms_key_id" {
  description = "KMS key ID for root volume encryption"
  type        = string
  default     = null
}

variable "root_volume_tags" {
  description = "Additional tags for the root volume"
  type        = map(string)
  default     = {}
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to the instance"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A map of tags to add to all volumes"
  type        = map(string)
  default     = {}
}

variable "use_num_suffix" {
  description = "Always append numerical suffix to instance name, even if instance_count is 1"
  type        = bool
  default     = false
}
