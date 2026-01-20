# S3 bucket for website hosting
resource "aws_s3_bucket" "website" {
  bucket = "${var.project_name}-${var.environment}-website-${data.aws_caller_identity.current.account_id}"
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy for CloudFront
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}

# S3 bucket logging (optional)
resource "aws_s3_bucket" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = "${var.project_name}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "website" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.website.id

  target_bucket = aws_s3_bucket.logs[0].id
  target_prefix = "s3-access/"
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for ${var.project_name} website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = var.price_class
  comment             = "${var.project_name} ${var.environment} distribution"

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.website.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website.id}"

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # CORS-S3Origin

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.domain_name == "" ? true : false
    # Uncomment and configure when using custom domain
    # acm_certificate_arn      = var.domain_name != "" ? aws_acm_certificate.cert[0].arn : null
    # ssl_support_method       = var.domain_name != "" ? "sni-only" : null
    # minimum_protocol_version = var.domain_name != "" ? "TLSv1.2_2021" : null
  }

  # Uncomment when using custom domain
  # aliases = var.domain_name != "" ? [var.domain_name] : []

  dynamic "logging_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      bucket          = aws_s3_bucket.logs[0].bucket_domain_name
      prefix          = "cloudfront/"
      include_cookies = false
    }
  }
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Optional: ACM Certificate for custom domain
# Uncomment when using custom domain
# resource "aws_acm_certificate" "cert" {
#   count             = var.domain_name != "" ? 1 : 0
#   provider          = aws.us_east_1
#   domain_name       = var.domain_name
#   validation_method = "DNS"
# 
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# Optional: Route53 DNS record for custom domain
# Uncomment when using custom domain
# resource "aws_route53_record" "website" {
#   count   = var.domain_name != "" ? 1 : 0
#   zone_id = var.route53_zone_id
#   name    = var.domain_name
#   type    = "A"
# 
#   alias {
#     name                   = aws_cloudfront_distribution.website.domain_name
#     zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
