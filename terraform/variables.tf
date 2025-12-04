variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "project_name" {
  type        = string
  default     = "devops-assignment"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "app_s3_bucket" {
  type        = string
  description = "S3 bucket containing the application JAR"
}

variable "app_s3_key" {
  type        = string
  default     = "demo-api.jar"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  default     = 2
}

variable "min_capacity" {
  type        = number
  default     = 2
}

variable "max_capacity" {
  type        = number
  default     = 4
}

variable "alb_certificate_arn" {
  type        = string
  default     = ""
  description = "ACM certificate ARN for HTTPS listener (optional). If empty, only HTTP is used."
}

variable "route53_zone_id" {
  type        = string
  default     = ""
  description = "Optional Route53 Hosted Zone ID to create a DNS record"
}

variable "route53_record_name" {
  type        = string
  default     = "api"
  description = "Record name prefix (e.g., api.example.com)"
}

