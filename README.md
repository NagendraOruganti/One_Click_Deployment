# Objective & Architecture

Client → ALB (public subnets) → Target Group → ASG → EC2 (private subnets)

NAT Gateway for outbound internet from private subnets

No public IPs on EC2

# Components

VPC, 2 public + 2 private subnets

IGW, NAT Gateway

ALB (HTTP, optional HTTPS) with /health check

Target Group to ASG

Launch Template with user-data installing Java & pulling JAR from S3

ASG in private subnets

Security Groups: ALB SG (HTTP/HTTPS from internet), EC2 SG (8080 from ALB SG only)

IAM Role: CloudWatch Logs, SSM, S3 read

Optional Route53 record

# Deployment Steps

## 1. Setup Terraform Remote State Backend (One-time setup)

Run this once to create S3 bucket and DynamoDB table for Terraform state:

```bash
./scripts/setup-backend.sh
```

Then migrate your local state to S3:

```bash
cd terraform
terraform init -migrate-state
```

## 2. Deploy Infrastructure

Build the Java app and upload JAR to S3.

Set environment variables:

```bash
export APP_S3_BUCKET="my-demo-api-artifacts"
export APP_S3_KEY="demo-api.jar"
export AWS_REGION="us-east-1"
```

Run deployment:

```bash
./scripts/deploy.sh
```

Get ALB DNS from terraform output or run ./scripts/test.sh.

## 3. GitHub Actions Workflow

The workflow requires AWS credentials to be set as secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Ensure your IAM user has permissions for:
- EC2, VPC, ELB, IAM, S3, DynamoDB
- Access to the Terraform state S3 bucket and DynamoDB table

# Testing

curl http://<ALB_DNS>/

curl http://<ALB_DNS>/health

# Teardown

./scripts/destroy.sh to avoid charges.
