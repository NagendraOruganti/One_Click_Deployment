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

Build the Java app and upload JAR to S3.

Set APP_S3_BUCKET, APP_S3_KEY, AWS_REGION.

Run ./scripts/deploy.sh.

Get ALB DNS from terraform output or run ./scripts/test.sh.

# Testing

curl http://<ALB_DNS>/

curl http://<ALB_DNS>/health

# Teardown

./scripts/destroy.sh to avoid charges.
