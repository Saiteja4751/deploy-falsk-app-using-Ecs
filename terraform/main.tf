# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get Subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ECR Repository – try to fetch existing
data "aws_ecr_repository" "existing" {
  name = var.app_name
}

# IAM Role – check if exists
data "aws_iam_role" "existing" {
  name = var.iam_role_name
}

# Fallback IAM Role if not exists
resource "aws_iam_role" "ecs_task_execution_role" {
  count = can(data.aws_iam_role.existing.arn) ? 0 : 1
  name  = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  count      = can(data.aws_iam_role.existing.arn) ? 0 : 1
  role       = aws_iam_role.ecs_task_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Group – use if exists, else create
data "aws_security_group" "existing" {
  filter {
    name   = "group-name"
    values = ["${var.app_name}-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "allow_all" {
  count = can(data.aws_security_group.existing.id) ? 0 : 1

  name        = "${var.app_name}-sg"
  description = "Allow all traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Use locals to toggle between existing/new resources
locals {
  sg_id     = can(data.aws_security_group.existing.id) ? data.aws_security_group.existing.id : aws_security_group.allow_all[0].id
  iam_role  = can(data.aws_iam_role.existing.arn) ? data.aws_iam_role.existing.arn : aws_iam_role.ecs_task_execution_role[0].arn
  image_url = "${var.app_name}:latest"
}

# ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = local.iam_role

  container_definitions = jsonencode([{
    name      = var.app_name
    image     = local.image_url
    essential = true
    portMappings = [{
      containerPort = 5000
      hostPort      = 5000
    }]
  }])
}

# ECS Service
resource "aws_ecs_service" "app_service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [local.sg_id]
  }

  depends_on = [aws_ecs_task_definition.app_task]
}
