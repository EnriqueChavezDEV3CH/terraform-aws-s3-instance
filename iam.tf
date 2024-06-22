resource "aws_iam_policy" "api_bucket_full_access" {
  name   = "${var.project_name}-${var.project_environment}-bucket-full-access"
  policy = data.aws_iam_policy_document.api_resources_bucket_full_access.json
}

resource "aws_iam_group" "api_group" {
  name = "${var.project_name}-${var.project_environment}"
}

resource "aws_iam_group_policy_attachment" "api_group_api_bucket_full_access" {
  group      = aws_iam_group.api_group.name
  policy_arn = aws_iam_policy.api_bucket_full_access.arn
}

resource "aws_iam_user" "api_user" {
  name = "${var.project_name}-${var.project_environment}-api-user"
}

resource "aws_iam_access_key" "api_user_access_key" {
  user = aws_iam_user.api_user.name
}

resource "aws_iam_user_group_membership" "api_user_groups" {
  groups = [
    aws_iam_group.api_group.name
  ]
  user = aws_iam_user.api_user.name
}

resource "local_file" "api_user_secret_key" {
  filename = "api_key/${var.project_name}_${var.project_environment}_secret_key.txt"
  content  = aws_iam_access_key.api_user_access_key.secret
}

resource "local_file" "api_user_access_key" {
  filename = "api_key/${var.project_name}_${var.project_environment}_access_key.txt"
  content  = aws_iam_access_key.api_user_access_key.id
}
