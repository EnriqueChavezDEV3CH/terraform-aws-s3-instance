locals {
  current_date = timestamp()
  date_only    = formatdate("DDMMYYYY", local.current_date)
  s3_origin_id = upper("${var.project_name}${var.project_environment}${local.date_only}")
}
