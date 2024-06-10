variable "vpc_id" {
  description = "VPC ID"
}

variable "env" {
  description = "Environment"
}

variable "app_name" {
  description = "Application name"
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}
