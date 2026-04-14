resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-cluster"
  })
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30

  tags = merge(var.tags, {
    Name = "${var.project_name}-logs"
  })
}

resource "aws_ecs_task_definition" "service" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.project_name
      image     = var.ecr_repository_url
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${var.project_name}-task"
  })
}

resource "aws_ecs_service" "main" {
  name                 = "${var.project_name}-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.service.arn
  desired_count        = var.desired_count
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = 120

  tags = merge(var.tags, {
    Name = "${var.project_name}-service"
  })
}