########################################
# VPC Outputs
########################################
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

########################################
# Subnet Outputs
########################################
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

########################################
# Networking Outputs
########################################
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (null if not created)"
  value       = var.create_nat_gateway ? aws_nat_gateway.main[0].id : null
}

########################################
# S3 Outputs
########################################
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.app_data.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.app_data.arn
}

output "s3_bucket_region" {
  description = "Region of the S3 bucket"
  value       = aws_s3_bucket.app_data.region
}

########################################
# AWS Account Information
########################################
output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}

########################################
# Resource Summary
########################################
output "resource_summary" {
  description = "Summary of created resources"
  value = {
    vpc_created              = true
    public_subnets_count     = length(aws_subnet.public)
    private_subnets_count    = length(aws_subnet.private)
    s3_bucket_created        = true
    s3_versioning_enabled    = var.enable_s3_versioning
    internet_gateway_created = true
    nat_gateway_created      = var.create_nat_gateway
  }
}
