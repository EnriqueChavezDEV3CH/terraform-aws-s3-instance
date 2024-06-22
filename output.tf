output "bucket_name" {
  value = aws_s3_bucket.bucket_api_resources.id
}

output "s3_origin_id" {
  value = local.s3_origin_id
}
