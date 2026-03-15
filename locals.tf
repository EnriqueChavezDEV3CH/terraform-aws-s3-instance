locals {
  s3_origin_id = upper("${var.project_name}-${var.project_environment}-origin")
}
