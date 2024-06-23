variable "env" {
  description = "Environment"
}

variable "app_name" {
  description = "Application name"
}

variable "ecs_endpoint" {
  description = "ECS endpoint"
}

variable "github_token" {
  description = "GitHub token"
  type        = string
  sensitive   = true
}

locals {
  repository = "https://github.com/rindy1123/go_app_front"
}
