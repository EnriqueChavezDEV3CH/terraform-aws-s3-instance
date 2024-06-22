resource "aws_s3_bucket" "bucket_api_resources" {
  bucket = lower("${var.project_name}-${var.project_environment}")
  tags = {
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_api_resources" {
  bucket = aws_s3_bucket.bucket_api_resources.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_api_resources" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_api_resources]

  bucket = aws_s3_bucket.bucket_api_resources.id
  acl    = "private"
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket_api_resources.id

  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_s3_bucket_cors_configuration" "bucket_api_cors" {
  bucket = aws_s3_bucket.bucket_api_resources.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    expose_headers  = var.cors_expose_headers
    allowed_origins = var.cors_allowed_origins
    max_age_seconds = var.cors_max_age_seconds
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_access_bucket_policy" {
  bucket = aws_s3_bucket.bucket_api_resources.id

  block_public_acls       = var.policy_block_public_acls
  ignore_public_acls      = var.policy_ignore_public_acls
  block_public_policy     = var.policy_block_public_policy
  restrict_public_buckets = var.policy_restrict_public_buckets
}
