output "alb_dns_name" {
  value       = aws_lb.app_alb.dns_name
  description = "Public DNS name of the ALB"
}

output "api_url" {
  value       = "http://${aws_lb.app_alb.dns_name}"
  description = "Base URL of the API (HTTP)"
}

