#!/bin/bash

# Account argument (e.g., MLOps, INC, Digitalinfra)
ACCOUNT=$1

if [[ -z "$ACCOUNT" ]]; then
  echo "Usage: $0 <account-name: MLOps|INC|Digitalinfra>"
  exit 1
fi

# Remove existing AWS credentials by deleting the files
echo "🧹 Removing existing AWS credentials..."
rm -f ~/.aws/credentials ~/.aws/config

# Use the exact account name passed in
SECRET_NAME="${ACCOUNT}-credentials"
echo "🔐 Fetching credentials for AWS account: $ACCOUNT (Secret: $SECRET_NAME)"

# Fetch credentials from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --query 'SecretString' --output text 2>/dev/null)

if [[ -z "$SECRET_JSON" ]]; then
  echo "❌ Error: Failed to retrieve secret for account: $ACCOUNT"
  exit 1
fi

AWS_ACCESS_KEY=$(echo "$SECRET_JSON" | jq -r .AWS_ACCESS_KEY_ID)
AWS_SECRET_KEY=$(echo "$SECRET_JSON" | jq -r .AWS_SECRET_ACCESS_KEY)

if [[ -z "$AWS_ACCESS_KEY" || -z "$AWS_SECRET_KEY" ]]; then
  echo "❌ Error: Missing keys in secret."
  exit 1
fi
# Configure AWS CLI with retrieved credentials
aws configure set aws_access_key_id "$AWS_ACCESS_KEY"
aws configure set aws_secret_access_key "$AWS_SECRET_KEY"
aws configure set region "us-east-1"
echo "✅ AWS CLI configured for account: $ACCOUNT"

cd /home/ubuntu/tf-files && terraform init
