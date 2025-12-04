#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../terraform"

terraform destroy -auto-approve \
  -var="app_s3_bucket=${APP_S3_BUCKET}" \
  -var="app_s3_key=${APP_S3_KEY}" \
  -var="aws_region=${AWS_REGION:-us-east-1}"

