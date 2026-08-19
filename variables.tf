########################################
# Project Configuration
########################################
variable "project_name" {
  type        = string
  description = "Name of the project (used for resource naming)"
  default     = "aether-test"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

########################################
# AWS Configuration
########################################
variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "eu-west-2"
}

########################################
# Network Configuration
########################################
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

########################################
# Feature Flags
########################################
variable "enable_s3_versioning" {
  type        = bool
  description = "Enable versioning for S3 buckets"
  default     = true
}

variable "create_nat_gateway" {
  type        = bool
  description = "Create NAT Gateway for private subnet internet access"
  default     = false
}

########################################
# Tags
########################################
variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}
