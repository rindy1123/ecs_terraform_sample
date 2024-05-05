variable "region" {
  default     = "ap-northeast-1"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}
