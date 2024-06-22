# AWS S3 bucket Terraform module

## Usage

```hcl
provider "aws" {
  region = "us-east-2"
  profile = "project"
}

...

module "s3_bucket" {
  source  = "github.com/EnriqueChavezDEV3CH/terraform-aws-s3-instance?ref=v0.0.2"
  project_name = "project"
  project_environment = "develop"
}
```

## Inputs

| Name                           | Description                                                                                               | Type           | Default                   | Required |
| ------------------------------ | --------------------------------------------------------------------------------------------------------- | -------------- | ------------------------- | :------: |
| project_name                   | Project's name                                                                                            | `string`       | `""`                      |   yes    |
| project_environment            | Project environment                                                                                       | `string`       | `""`                      |   yes    |
| site_domain                    | Url of the site to be added to the S3 CORS.                                                               | `string`       | `"*"`                     |    no    |
| cors_allowed_headers           | Set of Headers that are specified in the `Access-Control-Request-Headers` header.                         | `list(string)` | `["*"]`                   |    no    |
| cors_allowed_methods           | One or more HTTP methods that you allow the origin to execute.                                            | `list(string)` | `["GET", "HEAD", "POST"]` |    no    |
| cors_expose_headers            | One or more headers in the response that you want customers to be able to access from their applications. | `list(string)` | `[]`                      |    no    |
| cors_allowed_origins           | Set of origins you want customers to be able to access the bucket from.                                   | `list(string)` | `["*"]`                   |    no    |
| cors_max_age_seconds           | The time in seconds that your browser is to cache the preflight response for the specified resource.      | `number`       | `3000`                    |    no    |
| policy_block_public_acls       | If S3 block public ACLs.                                                                                  | `bool`         | `false`                   |    no    |
| policy_ignore_public_acls      | If S3 ignore public ACLs for this bucket.                                                                 | `bool`         | `false`                   |    no    |
| policy_block_public_policy     | If S3 url of the site to be added to the S3 CORS.                                                         | `bool`         | `false`                   |    no    |
| policy_restrict_public_buckets | If S3 should restrict public bucket policies for this bucket.                                             | `bool`         | `false`                   |    no    |

## Outputs

| Name        |      Description       |
| ----------- | :--------------------: |
| bucket_name | The name og the bucket |

## Resources that return

| Extension      | Folder    |                       Description                       |
| -------------- | --------- | :-----------------------------------------------------: |
| access_key.txt | ./api_key | Text file with the key to access the bucket through IAM |
| secret_key.txt | ./api_key |  Text file with the secret key to the bucket using IAM  |
