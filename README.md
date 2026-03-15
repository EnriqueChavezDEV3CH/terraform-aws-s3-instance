# terraform-aws-s3-instance

Modulo de Terraform para crear un bucket S3 con CloudFront condicional, usuario IAM con acceso restringido al bucket y configuracion CORS personalizable.

Mantenido por **dev3ch**.

## Uso basico

### S3 sin CloudFront (default)

```hcl
provider "aws" {
  region  = "us-east-2"
  profile = "my-profile"
}

module "s3_bucket" {
  source              = "github.com/dev3ch/terraform-aws-s3-instance?ref=v1.0.0"
  project_name        = "my-app"
  project_environment = "dev"
}
```

### S3 con CloudFront habilitado

```hcl
module "s3_bucket" {
  source              = "github.com/dev3ch/terraform-aws-s3-instance?ref=v1.0.0"
  project_name        = "my-app"
  project_environment = "prod"
  enable_cloudfront   = true
}
```

### S3 + CloudFront para SPA (React, Vue, Angular, etc.)

Habilita `enable_spa_mode` para que CloudFront redirija errores 403/404 a `index.html`, necesario para que el routing del frontend funcione correctamente:

```hcl
module "s3_bucket" {
  source              = "github.com/dev3ch/terraform-aws-s3-instance?ref=v1.0.0"
  project_name        = "my-app"
  project_environment = "prod"
  enable_cloudfront   = true
  enable_spa_mode     = true
}
```

### S3 con versionado y encriptacion

```hcl
module "s3_bucket" {
  source              = "github.com/dev3ch/terraform-aws-s3-instance?ref=v1.0.0"
  project_name        = "my-app"
  project_environment = "prod"
  enable_versioning   = true
  enable_encryption   = true
}
```

### CORS restringido a dominios especificos

Por defecto CORS permite todos los origenes (`["*"]`). Para produccion se recomienda restringirlo a los dominios que realmente consumen el bucket (tu CDN, tu frontend, etc.):

```hcl
module "s3_bucket" {
  source              = "github.com/dev3ch/terraform-aws-s3-instance?ref=v1.0.0"
  project_name        = "my-app"
  project_environment = "prod"
  enable_cloudfront   = true

  cors_allowed_origins = [
    "https://midominio.com",
    "https://www.midominio.com",
    "https://cdn.midominio.com",
  ]
}
```

> **Nota sobre CORS y CDNs:** La configuracion CORS se aplica en S3 (el origin). CloudFront, Bunnynet u otro CDN actuan como proxy y reenvian los headers CORS que S3 responde. Por eso es correcto configurar CORS en S3 aunque el acceso siempre sea a traves de un CDN.

### Ejemplo completo

```hcl
module "s3_bucket" {
  source              = "github.com/dev3ch/terraform-aws-s3-instance?ref=v1.0.0"
  project_name        = "my-app"
  project_environment = "prod"

  # CloudFront + SPA
  enable_cloudfront = true
  enable_spa_mode   = true

  # Proteccion del bucket
  enable_versioning = true
  enable_encryption = true

  # CORS restringido
  cors_allowed_origins = ["https://midominio.com"]
  cors_allowed_methods = ["GET", "HEAD"]
  cors_allowed_headers = ["*"]
  cors_max_age_seconds = 86400

  # Acceso publico bloqueado (default)
  policy_block_public_acls       = true
  policy_ignore_public_acls      = true
  policy_block_public_policy     = true
  policy_restrict_public_buckets = true
}
```

## Acceso a credenciales IAM

Al ejecutar `terraform apply`, las credenciales del usuario IAM se generan automaticamente en la carpeta `api_key/`:

```
api_key/
  {project_name}_{project_environment}_access_key.txt
  {project_name}_{project_environment}_secret_key.txt
```

> **Importante:** Esta carpeta esta incluida en `.gitignore` para evitar que se suba al repositorio. Guarda estas credenciales en un lugar seguro.

Tambien puedes obtenerlas via outputs:

```bash
terraform output iam_access_key_id
terraform output iam_secret_access_key
```

El usuario IAM creado solo tiene acceso al bucket de este modulo (lectura, escritura, eliminacion de objetos).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Nombre del proyecto, usado como prefijo en los recursos | `string` | — | si |
| `project_environment` | Ambiente del proyecto (dev, staging, prod, etc.) | `string` | — | si |
| `enable_cloudfront` | Habilitar distribucion CloudFront para el bucket S3 | `bool` | `false` | no |
| `enable_spa_mode` | Redirigir errores 403/404 a index.html en CloudFront (para SPAs). Requiere `enable_cloudfront = true` | `bool` | `false` | no |
| `enable_versioning` | Habilitar versionado en el bucket S3 | `bool` | `false` | no |
| `enable_encryption` | Habilitar encriptacion SSE en el bucket S3 | `bool` | `false` | no |
| `encryption_algorithm` | Algoritmo de encriptacion (`AES256` o `aws:kms`) | `string` | `"AES256"` | no |
| `cors_allowed_headers` | Headers permitidos en la configuracion CORS del bucket | `list(string)` | `["*"]` | no |
| `cors_allowed_methods` | Metodos HTTP permitidos en la configuracion CORS del bucket | `list(string)` | `["GET", "HEAD", "POST"]` | no |
| `cors_expose_headers` | Headers expuestos en la respuesta CORS | `list(string)` | `[]` | no |
| `cors_allowed_origins` | Origenes permitidos en CORS. Usa `["*"]` para todos o especifica dominios | `list(string)` | `["*"]` | no |
| `cors_max_age_seconds` | Tiempo en segundos que el navegador cachea la respuesta preflight CORS | `number` | `3000` | no |
| `policy_block_public_acls` | Bloquear ACLs publicas en el bucket | `bool` | `true` | no |
| `policy_ignore_public_acls` | Ignorar ACLs publicas en el bucket | `bool` | `true` | no |
| `policy_block_public_policy` | Bloquear politicas publicas en el bucket | `bool` | `true` | no |
| `policy_restrict_public_buckets` | Restringir acceso publico al bucket | `bool` | `true` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|:---------:|
| `bucket_name` | Nombre del bucket S3 | no |
| `bucket_arn` | ARN del bucket S3 | no |
| `bucket_regional_domain_name` | Domain name regional del bucket S3 | no |
| `s3_origin_id` | ID del origen S3 para CloudFront | no |
| `cloudfront_distribution_id` | ID de la distribucion CloudFront (`null` si deshabilitado) | no |
| `cloudfront_domain_name` | Domain name de la distribucion CloudFront (`null` si deshabilitado) | no |
| `cloudfront_distribution_arn` | ARN de la distribucion CloudFront (`null` si deshabilitado) | no |
| `iam_user_name` | Nombre del usuario IAM | no |
| `iam_user_arn` | ARN del usuario IAM | no |
| `iam_access_key_id` | Access key ID del usuario IAM | si |
| `iam_secret_access_key` | Secret access key del usuario IAM | si |

## Recursos creados

### Siempre

- `aws_s3_bucket` — Bucket S3
- `aws_s3_bucket_ownership_controls` — Control de ownership del bucket
- `aws_s3_bucket_acl` — ACL del bucket (private)
- `aws_s3_bucket_cors_configuration` — Configuracion CORS
- `aws_s3_bucket_public_access_block` — Bloqueo de acceso publico
- `aws_iam_user` — Usuario IAM con acceso al bucket
- `aws_iam_access_key` — Access key del usuario IAM
- `aws_iam_policy` — Politica IAM restringida al bucket
- `aws_iam_group` — Grupo IAM
- `aws_iam_group_policy_attachment` — Attachment de politica al grupo
- `aws_iam_user_group_membership` — Membership del usuario al grupo

### Condicionales

| Recurso | Condicion |
|---------|-----------|
| `aws_s3_bucket_versioning` | `enable_versioning = true` |
| `aws_s3_bucket_server_side_encryption_configuration` | `enable_encryption = true` |
| `aws_cloudfront_distribution` | `enable_cloudfront = true` |
| `aws_cloudfront_origin_access_control` | `enable_cloudfront = true` |
| `aws_cloudfront_cache_policy` | `enable_cloudfront = true` |
| `aws_s3_bucket_policy` | `enable_cloudfront = true` |
| Custom error responses (403/404 → index.html) | `enable_spa_mode = true` |

## Contacto

Mantenido por **dev3ch**.

- Web: [dev3ch.com](https://dev3ch.com)
- Email: [developer@dev3ch.com](mailto:developer@dev3ch.com)
- GitHub: [github.com/dev3ch](https://github.com/dev3ch)
