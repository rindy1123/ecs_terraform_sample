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

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "private-subnet-1-cidr-block" {
  default = "10.0.1.0/24"
  type = string
}

variable "private-subnet-2-cidr-block" {
  default = "10.0.2.0/24"
  type = string
}

variable "private-subnet-3-cidr-block" {
  default = "10.0.3.0/24"
  type = string
}

variable "public-subnet-1-cidr-block" {
  default = "10.0.4.0/24"
  type = string
}

variable "public-subnet-2-cidr-block" {
  default = "10.0.5.0/24"
  type = string
}

variable "public-subnet-3-cidr-block" {
  default = "10.0.6.0/24"
  type = string
}

