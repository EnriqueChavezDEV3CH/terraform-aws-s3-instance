data "aws_iam_policy_document" "api_resources_bucket_full_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_api_resources.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}
