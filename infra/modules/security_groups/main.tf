terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ALB (non deploye en L3) : HTTP depuis Internet.
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-sg-alb"
  description = "ALB: HTTP public"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-alb"
  }
}

# Frontend (premiere instance L3) : HTTP depuis l'ALB, egress via NAT.
resource "aws_security_group" "frontend" {
  name        = "${var.name_prefix}-sg-frontend"
  description = "Frontend prive: HTTP from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Permet un test interne (ex. curl depuis une autre instance du VPC) sans ALB.
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-frontend"
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.name_prefix}-sg-backend"
  description = "Backend prive: API from frontend"
  vpc_id      = var.vpc_id

  ingress {
    description     = "API from frontend"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-backend"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-sg-db"
  description = "RDS: only from backend"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    description = "No internet route - VPC traffic only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.name_prefix}-sg-db"
  }
}
