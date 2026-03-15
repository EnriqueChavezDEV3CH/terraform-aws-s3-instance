output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.bucket_api_resources.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.bucket_api_resources.arn
}

output "bucket_regional_domain_name" {
  description = "Domain name regional del bucket S3"
  value       = aws_s3_bucket.bucket_api_resources.bucket_regional_domain_name
}

output "s3_origin_id" {
  description = "ID del origen S3 para CloudFront"
  value       = local.s3_origin_id
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución CloudFront"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.s3_distribution[0].id : null
}

output "cloudfront_domain_name" {
  description = "Domain name de la distribución CloudFront"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.s3_distribution[0].domain_name : null
}

output "cloudfront_distribution_arn" {
  description = "ARN de la distribución CloudFront"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.s3_distribution[0].arn : null
}

output "iam_user_name" {
  description = "Nombre del usuario IAM"
  value       = aws_iam_user.api_user.name
}

output "iam_user_arn" {
  description = "ARN del usuario IAM"
  value       = aws_iam_user.api_user.arn
}

output "iam_access_key_id" {
  description = "Access key ID del usuario IAM"
  value       = aws_iam_access_key.api_user_access_key.id
  sensitive   = true
}

output "iam_secret_access_key" {
  description = "Secret access key del usuario IAM"
  value       = aws_iam_access_key.api_user_access_key.secret
  sensitive   = true
}
