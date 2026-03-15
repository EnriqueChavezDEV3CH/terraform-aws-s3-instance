variable "project_name" {
  type        = string
  description = "Nombre del proyecto, usado como prefijo en los recursos"
}

variable "project_environment" {
  type        = string
  description = "Ambiente del proyecto (dev, staging, prod, etc.)"
}

variable "enable_cloudfront" {
  type        = bool
  description = "Habilitar distribución CloudFront para el bucket S3"
  default     = false
}

variable "cors_allowed_headers" {
  type        = list(string)
  description = "Headers permitidos en la configuración CORS del bucket"
  default     = ["*"]
}

variable "cors_allowed_methods" {
  type        = list(string)
  description = "Métodos HTTP permitidos en la configuración CORS del bucket"
  default     = ["GET", "HEAD", "POST"]
}

variable "cors_expose_headers" {
  type        = list(string)
  description = "Headers expuestos en la respuesta CORS"
  default     = []
}

variable "cors_allowed_origins" {
  type        = list(string)
  description = "Orígenes permitidos en la configuración CORS del bucket. Usa [\"*\"] para permitir todos o especifica dominios (ej: [\"https://midominio.com\"])"
  default     = ["*"]
}

variable "cors_max_age_seconds" {
  type        = number
  description = "Tiempo en segundos que el navegador cachea la respuesta preflight CORS"
  default     = 3000
}

variable "enable_versioning" {
  type        = bool
  description = "Habilitar versionado en el bucket S3"
  default     = false
}

variable "enable_encryption" {
  type        = bool
  description = "Habilitar encriptación SSE en el bucket S3 (AES256 por defecto)"
  default     = false
}

variable "encryption_algorithm" {
  type        = string
  description = "Algoritmo de encriptación para el bucket S3 (aws:kms o AES256)"
  default     = "AES256"
}

variable "enable_spa_mode" {
  type        = bool
  description = "Habilitar custom error responses en CloudFront para SPA (redirige 403/404 a index.html). Requiere enable_cloudfront = true"
  default     = false
}

variable "policy_block_public_acls" {
  type        = bool
  description = "Bloquear ACLs públicas en el bucket"
  default     = true
}

variable "policy_ignore_public_acls" {
  type        = bool
  description = "Ignorar ACLs públicas en el bucket"
  default     = true
}

variable "policy_block_public_policy" {
  type        = bool
  description = "Bloquear políticas públicas en el bucket"
  default     = true
}

variable "policy_restrict_public_buckets" {
  type        = bool
  description = "Restringir acceso público al bucket"
  default     = true
}
