variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "website"
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

# S3 Configuration
variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for the S3 bucket"
  type        = bool
  default     = true
}

variable "objects_expiration_days" {
  description = "Number of days after which objects expire (0 means never expire)"
  type        = number
  default     = 0
}

# CloudFront Configuration
variable "domain_names" {
  description = "List of domain names for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "default_root_object" {
  description = "Default root object for the CloudFront distribution"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100" # US, Canada, Europe
}

variable "min_ttl" {
  description = "Minimum TTL for the CloudFront cache"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default TTL for the CloudFront cache"
  type        = number
  default     = 86400 # 1 day
}

variable "max_ttl" {
  description = "Maximum TTL for the CloudFront cache"
  type        = number
  default     = 31536000 # 1 year
}

variable "ordered_cache_behaviors" {
  description = "Ordered cache behaviors for the CloudFront distribution"
  type = list(object({
    path_pattern         = string
    allowed_methods      = list(string)
    cached_methods       = list(string)
    forward_query_string = bool
    forward_cookies      = string
    min_ttl              = number
    default_ttl          = number
    max_ttl              = number
  }))
  default = []
}

variable "geo_restriction_type" {
  description = "Geo restriction type for the CloudFront distribution"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "Geo restriction locations for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "web_acl_id" {
  description = "Web ACL ID for the CloudFront distribution"
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enable logging for the CloudFront distribution"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "Bucket to store CloudFront logs"
  type        = string
  default     = ""
}
