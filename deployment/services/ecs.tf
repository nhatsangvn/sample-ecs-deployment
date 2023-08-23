resource "aws_ecs_task_definition" "rg-ops" {
  family                    = "task-rg-ops"
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  cpu                       = var.container_cpu
  memory                    = var.container_memory
  execution_role_arn        = "arn:aws:iam::995465982134:role/ecsTaskExecutionRole"
  container_definitions     = jsonencode([
    {
      name                = "rg-ops"
      image               = "${data.aws_ecr_repository.rg-ops.repository_url}:latest@${data.aws_ecr_image.rg-ops.image_digest}"
      cpu                 = var.container_cpu
      memory              = var.container_memory
      essential           = true
      environment         = "${local.app_env_variables}",
      portMappings        = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_cluster" "rg-ops" {
  name = "cluster-rg-ops"
}

resource "aws_security_group" "lb-to-ecs-secgroup" {
  name = "lb-to-ecs-secgroup"

  # Allow inbound HTTP requests
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = local.tcp_protocol
    security_groups = [aws_security_group.lb-secgroup.id]
  }

  # Allow all outbound requests
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_ecs_service" "rg-ops" {
  name                  = "svc-rg-ops"
  cluster               = aws_ecs_cluster.rg-ops.id
  launch_type           = "FARGATE"
  task_definition       = aws_ecs_task_definition.rg-ops.arn
  desired_count         = var.desired_count
  force_new_deployment  = true

  network_configuration {
    subnets           = data.aws_subnets.default.ids
    security_groups   = [aws_security_group.lb-to-ecs-secgroup.id]
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.rg-ops.arn
    container_name   = "rg-ops"
    container_port   = var.app_port
  }
}
