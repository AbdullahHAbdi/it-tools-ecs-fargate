#!/bin/bash
set -e

AWS_REGION=${1:-"us-east-2"}
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
STATE_BUCKET="it-tools-terraform-state-aa"
ECR_REPO="it-tools-app"
GITHUB_REPO="AbdullahHAbdi/it-tools-ecs-fargate"
OIDC_ROLE="github-actions-role"
OIDC_PROVIDER="token.actions.githubusercontent.com"

echo "Bootstrap starting..."
echo "Account: $AWS_ACCOUNT_ID"
echo "Region:  $AWS_REGION"

echo ""
echo "[1/4] Creating S3 state bucket..."

if aws s3api head-bucket --bucket "$STATE_BUCKET" 2>/dev/null; then
    echo "  Bucket '$STATE_BUCKET' already exists, skipping."
else
    aws s3api create-bucket \
        --bucket "$STATE_BUCKET" \
        --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_REGION"

    aws s3api put-bucket-versioning \
        --bucket "$STATE_BUCKET" \
        --versioning-configuration Status=Enabled

    aws s3api put-public-access-block \
        --bucket "$STATE_BUCKET" \
        --public-access-block-configuration \
            BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

    echo "  Bucket '$STATE_BUCKET' created with versioning and public access blocked."
fi


echo ""
echo "[2/4] Creating ECR repository..."

if aws ecr describe-repositories --repository-names "$ECR_REPO" --region "$AWS_REGION" 2>/dev/null; then
    echo "  ECR repo '$ECR_REPO' already exists, skipping."
else
    aws ecr create-repository \
        --repository-name "$ECR_REPO" \
        --region "$AWS_REGION" \
        --image-tag-mutability IMMUTABLE \
        --image-scanning-configuration scanOnPush=true

    echo "  ECR repo '$ECR_REPO' created."
fi


echo ""
echo "[3/4] Creating OIDC identity provider..."

OIDC_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"

if aws iam get-open-id-connect-provider --open-id-connect-provider-arn "$OIDC_ARN" 2>/dev/null; then
    echo "  OIDC provider already exists, skipping."
else
    aws iam create-open-id-connect-provider \
        --url "https://${OIDC_PROVIDER}" \
        --client-id-list sts.amazonaws.com \
        --thumbprint-list ffffffffffffffffffffffffffffffffffffffff

    echo "  OIDC provider created."
fi


echo ""
echo "[4/4] Creating GitHub Actions IAM role..."

TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:${GITHUB_REPO}:*"
        }
      }
    }
  ]
}
EOF
)

if aws iam get-role --role-name "$OIDC_ROLE" 2>/dev/null; then
    echo "  IAM role '$OIDC_ROLE' already exists, skipping."
else
    aws iam create-role \
        --role-name "$OIDC_ROLE" \
        --assume-role-policy-document "$TRUST_POLICY"

    aws iam attach-role-policy \
        --role-name "$OIDC_ROLE" \
        --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

    echo "  IAM role '$OIDC_ROLE' created and policy attached."
fi


echo ""
echo "Bootstrap complete."
echo ""
echo "Next steps:"
echo "  1. Add this secret to GitHub Actions:"
echo "     AWS_ROLE_ARN = arn:aws:iam::${AWS_ACCOUNT_ID}:role/${OIDC_ROLE}"
echo "  2. Add this secret to GitHub Actions:"
echo "     AWS_REGION = ${AWS_REGION}"
echo "  3. Run the Terraform deploy pipeline to provision infrastructure"
echo "  4. Run the app pipeline to build and push the Docker image"
