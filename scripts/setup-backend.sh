#!/usr/bin/env bash
set -e

BUCKET_NAME="devops-assignment-terraform-state"
DYNAMODB_TABLE="devops-assignment-terraform-locks"
REGION="${AWS_REGION:-us-east-1}"

echo "Setting up Terraform remote state backend..."
echo "Bucket: $BUCKET_NAME"
echo "DynamoDB Table: $DYNAMODB_TABLE"
echo "Region: $REGION"

# Check if bucket exists
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "S3 bucket $BUCKET_NAME already exists"
else
  echo "Creating S3 bucket $BUCKET_NAME..."
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION"

  echo "Enabling versioning on S3 bucket..."
  aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

  echo "Enabling server-side encryption on S3 bucket..."
  aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
      "Rules": [{
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }]
    }'

  echo "Blocking public access on S3 bucket..."
  aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
      BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
fi

# Check if DynamoDB table exists
if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" --region "$REGION" 2>/dev/null; then
  echo "DynamoDB table $DYNAMODB_TABLE already exists"
else
  echo "Creating DynamoDB table $DYNAMODB_TABLE..."
  aws dynamodb create-table \
    --table-name "$DYNAMODB_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$REGION"

  echo "Waiting for DynamoDB table to be active..."
  aws dynamodb wait table-exists --table-name "$DYNAMODB_TABLE" --region "$REGION"
fi

echo ""
echo "Terraform backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Run 'cd terraform && terraform init -migrate-state' to migrate your local state to S3"
echo "2. Run 'terraform apply' to continue managing your infrastructure"
