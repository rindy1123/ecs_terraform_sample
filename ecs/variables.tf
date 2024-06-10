variable "vpc_id" {
  description = "VPC ID"
}

variable "env" {
  description = "Environment"
}

variable "app_name" {
  description = "Application name"
}

variable "public_subnets" {
  description = "Public subnets"
}

variable "private_subnets" {
  description = "Private subnets"
}

locals {
  secretsmanager_secret_arn = "arn:aws:secretsmanager:ap-northeast-1:938203255528:secret:prod/go_app-mtuIHc"
  app_count                 = 1
}
