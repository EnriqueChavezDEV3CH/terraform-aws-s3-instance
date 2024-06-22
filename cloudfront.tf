resource "aws_cloudfront_origin_access_control" "cloudfront_origin_access_control" {
  name                              = aws_s3_bucket.bucket_api_resources.bucket_regional_domain_name
  description                       = "Control de cloudfront para S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy" {
  name    = upper("${var.project_name}-${var.project_environment}-policy-cloudfront")
  comment = "Policy cloudfront"

  default_ttl = 31536000
  max_ttl     = 31536000
  min_ttl     = 31536000

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket_api_resources.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_origin_access_control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    cache_policy_id        = aws_cloudfront_cache_policy.cloudfront_cache_policy.id
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    project     = var.project_name
    environment = var.project_environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
