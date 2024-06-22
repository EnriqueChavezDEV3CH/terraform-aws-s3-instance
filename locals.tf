locals {
  current_date = jsondecode(data.http.current_date.response_body)["datetime"]
  date_only    = formatdate("DDMMYYYY", local.current_date)
  s3_origin_id = upper("${var.project_name}${var.project_environment}${local.date_only}")
}
