variable "region" {
  default     = "ap-northeast-1"
  description = "AWS region"
}

variable "profile" {
  default     = "terraform"
  description = "AWS profile"
}

variable "env" {
  default     = "prod"
  description = "Environment"
}

variable "app_name" {
  default     = "go-app"
  description = "Application name"
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub token"
  type        = string
  sensitive   = true
}

locals {
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24"]
}
