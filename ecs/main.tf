// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ecs_task_execution_role" {
  name                = "${var.app_name}-${var.env}-ecs-task-execution-role"

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "get_secret_value"
    policy = data.aws_iam_policy_document.secretsmanager.json
  }
}

data "aws_iam_policy_document" "secretsmanager" {
  statement {
    effect = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.app_name}-${var.env}-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = local.task_definitions
}

resource "aws_security_group" "task_sg" {
  name        = "${var.app_name}-${var.env}-ecs-sg"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.env}-cluster"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-${var.env}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = local.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.task_sg.id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.app_name
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.alb_listener, aws_cloudwatch_log_group.ecs_log_group]
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.app_name}-${var.env}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}
