# hello-world-tf

Minimal AWS network and storage baseline managed with Terraform. Creates a VPC with public and private subnets, an internet gateway, an optional NAT gateway, and a private S3 bucket. No compute resources.

## What it creates

- **VPC** — `10.0.0.0/16` by default, DNS support and hostnames enabled
- **2 public subnets** (`10.0.1.0/24`, `10.0.2.0/24`) — auto-assign public IPs, routed to the internet gateway
- **2 private subnets** (`10.0.10.0/24`, `10.0.20.0/24`) — own route table, no internet egress unless the NAT gateway is enabled
- **Internet gateway** + public route table
- **NAT gateway** (optional, off by default) — single NAT in the first public subnet with an Elastic IP; adds a default route for the private subnets
- **S3 bucket** — `<project>-<env>-app-data-<random-suffix>`, versioning on by default, all public access blocked

All resources are tagged with `Project`, `Environment`, `ManagedBy`, and `CreatedBy` via provider `default_tags`, plus anything passed in `additional_tags`.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.6.0 |
| AWS provider | ~> 5.0 |
| Random provider | ~> 3.6 |

AWS credentials must be available in the environment (profile, SSO, or environment variables).

## Usage

```sh
terraform init
terraform plan
terraform apply
```

State is local. Configure a remote backend before using this beyond experiments.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `project_name` | string | `aether-test` | Resource name prefix; lowercase letters, numbers, hyphens only |
| `environment` | string | `dev` | One of `dev`, `staging`, `prod` |
| `aws_region` | string | `eu-west-2` | AWS region |
| `vpc_cidr` | string | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidrs` | list(string) | `["10.0.1.0/24", "10.0.2.0/24"]` | Public subnet CIDRs |
| `private_subnet_cidrs` | list(string) | `["10.0.10.0/24", "10.0.20.0/24"]` | Private subnet CIDRs |
| `enable_s3_versioning` | bool | `true` | Toggle S3 bucket versioning |
| `create_nat_gateway` | bool | `false` | Create NAT gateway for private subnet egress |
| `additional_tags` | map(string) | `{}` | Extra tags merged into all resources |

## Outputs

VPC ID and CIDR, subnet IDs and CIDRs, internet gateway ID, public and private route table IDs, NAT gateway ID (null when disabled), S3 bucket name/ARN/region, AWS account ID and region, and a `resource_summary` object.

## Cost notes

Everything here is free or near-free except the NAT gateway: enabling `create_nat_gateway` costs roughly $0.05/hour plus data processing charges in eu-west-2. The single-NAT layout is a deliberate simplification for dev use; production would run one NAT per availability zone.
