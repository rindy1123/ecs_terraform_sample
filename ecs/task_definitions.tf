locals {
  task_definitions = jsonencode([
    {
      image = "938203255528.dkr.ecr.ap-northeast-1.amazonaws.com/go_todo:latest"
      cpu = 1024
      memory = 2048
      name = "go-app"
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 8080
          hostPort = 8080
          protocol = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/go_app"
          awslogs-create-group = "true"
          awslogs-region = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
      secrets = [
        {
          name = "DB_HOST"
          valueFrom = "${local.secretsmanager_secret_arn}:DB_HOST::"
        },
        {
          name = "DB_USER"
          valueFrom = "${local.secretsmanager_secret_arn}:DB_USER::"
        },
        {
          name = "DB_PASSWORD"
          valueFrom = "${local.secretsmanager_secret_arn}:DB_PASSWORD::"
        },
        {
          name = "DB_NAME"
          valueFrom = "${local.secretsmanager_secret_arn}:DB_NAME::"
        },
        {
          name = "DB_PORT"
          valueFrom = "${local.secretsmanager_secret_arn}:DB_PORT::"
        },
        {
          name = "DB_SSLMODE"
          valueFrom = "${local.secretsmanager_secret_arn}:DB_SSLMODE::"
        },
        {
          name = "GIN_MODE"
          valueFrom = "${local.secretsmanager_secret_arn}:GIN_MODE::"
        }
      ]
    }
  ])
}
