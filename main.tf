terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.48"
    }
  }

  required_version = "~> 1.8.2"
}

provider "aws" {
  region  = var.region
  profile = "terraform"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name                 = "go-app"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "go-app" {
  name       = "go-app"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "Go App"
  }
}

resource "aws_security_group" "rds" {
  name   = "go-app_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "go-app_rds"
  }
}

resource "aws_db_parameter_group" "go-app" {
  name   = "go-app"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "go-app" {
  identifier             = "go-app"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.1"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.go-app.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.go-app.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
