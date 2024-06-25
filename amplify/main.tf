resource "aws_amplify_app" "main" {
  name                 = "${var.app_name}-${var.env}-amplify"
  repository           = local.repository
  platform             = "WEB_COMPUTE"
  access_token         = var.github_token
  iam_service_role_arn = aws_iam_role.amplify_ssr_logging_role.arn

  environment_variables = {
    API_ENDPOINT = "http://${var.ecs_endpoint}"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = "main"

  framework = "Next.js - SSR"
  stage     = "PRODUCTION"

  environment_variables = {
    API_ENDPOINT = "http://${var.ecs_endpoint}"
  }
}

resource "aws_iam_role" "amplify_ssr_logging_role" {
  name                = "${var.app_name}-${var.env}-AmplifySSRLoggingRole"

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmplifyBackendDeployFullAccess"]
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "logging"
    policy = data.aws_iam_policy_document.ssr_logging_policy.json
  }
}

data "aws_iam_policy_document" "ssr_logging_policy" {
  statement {
    sid       = "PushLogs"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:ap-northeast-1:938203255528:log-group:/aws/amplify/*:log-stream:*"]
  }

  statement {
    sid       = "CreateLogGroup"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:ap-northeast-1:938203255528:log-group:/aws/amplify/*"]
  }

  statement {
    sid       = "DescribeLogGroups"
    effect    = "Allow"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["arn:aws:logs:ap-northeast-1:938203255528:log-group:*"]
  }
}
