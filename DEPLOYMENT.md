# Deployment Guide

This guide will walk you through deploying the micro front-end application to AWS.

## Prerequisites

- AWS Account
- AWS CLI installed and configured
- Terraform installed (version >= 1.0)
- GitHub account (for GitHub Actions)

## Step 1: AWS Setup

### Create IAM User for Deployment

1. Log in to AWS Console
2. Navigate to IAM > Users
3. Create a new user with programmatic access
4. Attach the following policies:
   - AmazonS3FullAccess
   - CloudFrontFullAccess
   - IAMReadOnlyAccess

5. Save the Access Key ID and Secret Access Key

### Configure AWS CLI

```bash
aws configure
# Enter your Access Key ID
# Enter your Secret Access Key
# Enter default region (e.g., us-east-1)
# Enter default output format (json)
```

## Step 2: Deploy Infrastructure with Terraform

### Initialize Terraform

```bash
cd terraform
terraform init
```

### Configure Variables (Optional)

Create a `terraform.tfvars` file:

```hcl
aws_region   = "us-east-1"
environment  = "prod"
project_name = "micro-frontend"
```

### Plan and Apply

```bash
# Review what will be created
terraform plan

# Create the infrastructure
terraform apply
```

Type `yes` when prompted to confirm.

### Save Outputs

After successful deployment, save these values:

```bash
# Get S3 bucket name
terraform output s3_bucket_name

# Get CloudFront distribution ID
terraform output cloudfront_distribution_id

# Get website URL
terraform output website_url
```

## Step 3: Manual Deployment (One-Time)

For the first deployment, upload files manually:

```bash
# From project root
cd public

# Upload to S3 (replace BUCKET_NAME with your bucket name)
aws s3 sync . s3://BUCKET_NAME/ --delete

# Invalidate CloudFront cache (replace DISTRIBUTION_ID)
aws cloudfront create-invalidation \
  --distribution-id DISTRIBUTION_ID \
  --paths "/*"
```

## Step 4: Setup GitHub Actions

### Add Secrets to GitHub

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
   - `S3_BUCKET_NAME`: From Terraform output
   - `CLOUDFRONT_DISTRIBUTION_ID`: From Terraform output

### Test the Workflow

```bash
# Make a small change to trigger deployment
echo "# Test" >> README.md
git add .
git commit -m "Test deployment"
git push origin main
```

Watch the deployment progress in the Actions tab.

## Step 5: Custom Domain (Optional)

### If you want to use a custom domain:

1. **Register or use existing domain in Route53**

2. **Update Terraform variables**:
```hcl
# terraform/terraform.tfvars
domain_name = "yourdomain.com"
```

3. **Uncomment domain-related resources in s3.tf**:
   - ACM certificate
   - Route53 record
   - CloudFront aliases

4. **Apply changes**:
```bash
terraform apply
```

5. **Verify DNS**:
Wait for DNS propagation (can take up to 48 hours, usually much faster)

## Step 6: Verify Deployment

### Check S3 Bucket

```bash
aws s3 ls s3://YOUR_BUCKET_NAME/ --recursive
```

### Check CloudFront Distribution

```bash
aws cloudfront get-distribution --id YOUR_DISTRIBUTION_ID
```

### Test the Website

Open the CloudFront URL in your browser:
```
https://YOUR_DISTRIBUTION_DOMAIN.cloudfront.net
```

## Troubleshooting

### Issue: Files not updating

**Solution**: Invalidate CloudFront cache
```bash
aws cloudfront create-invalidation \
  --distribution-id YOUR_DISTRIBUTION_ID \
  --paths "/*"
```

### Issue: Access Denied errors

**Solution**: Check S3 bucket policy and CloudFront OAC configuration
```bash
aws s3api get-bucket-policy --bucket YOUR_BUCKET_NAME
```

### Issue: Terraform state locked

**Solution**: Force unlock (use with caution)
```bash
terraform force-unlock LOCK_ID
```

### Issue: GitHub Actions failing

**Solution**: Check the following:
1. Secrets are correctly set
2. AWS credentials have proper permissions
3. S3 bucket and CloudFront distribution exist
4. Check Actions logs for specific error messages

## Maintenance

### Update Content

Simply push to the main branch - GitHub Actions will handle deployment:

```bash
git add .
git commit -m "Update content"
git push origin main
```

### Update Infrastructure

Modify Terraform files and apply:

```bash
cd terraform
terraform plan
terraform apply
```

### Monitor Costs

Check AWS Cost Explorer regularly. Typical costs:
- S3: ~$0.023 per GB per month
- CloudFront: ~$0.085 per GB transferred
- Minimal costs for small websites (<$5/month for low traffic)

### Backup

S3 versioning is enabled by default. To restore a previous version:

```bash
aws s3api list-object-versions --bucket YOUR_BUCKET_NAME
aws s3api get-object --bucket YOUR_BUCKET_NAME --key FILE --version-id VERSION_ID output.file
```

## Clean Up

To destroy all resources (be careful!):

```bash
cd terraform
terraform destroy
```

This will:
1. Delete CloudFront distribution
2. Delete S3 buckets
3. Remove all associated resources

**Note**: CloudFront distribution deletion can take 15-30 minutes.

## Security Best Practices

1. **Enable MFA** on your AWS account
2. **Rotate access keys** regularly
3. **Use least privilege** IAM policies
4. **Enable CloudTrail** for audit logging
5. **Enable AWS Config** for compliance monitoring
6. **Set up billing alerts** to avoid unexpected costs
7. **Use Terraform backend** with state locking for team environments

## Support

For issues:
1. Check AWS CloudWatch logs
2. Review GitHub Actions logs
3. Consult AWS documentation
4. Open an issue on GitHub

---

Last Updated: 2026-01-20
