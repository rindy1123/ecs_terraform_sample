resource "aws_security_group" "rds" {
  name   = "${var.app_name}-${var.env}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-${var.env}-rds"
  }
}

resource "aws_db_parameter_group" "go-app" {
  name   = "${var.app_name}-${var.env}-db-parameter-group"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

resource "aws_db_instance" "go-app" {
  identifier             = "${var.app_name}-${var.env}-rds"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.1"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.go-app.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
