resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

# En AWS Academy normalmente se usa LabRole, igual que en el ejemplo del profesor.
data "aws_iam_role" "lab" {
  name = "LabRole"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = data.aws_iam_role.lab.arn

  container_definitions = jsonencode([
    {
      name  = "ventas-backend"
      image = "${aws_ecr_repository.backend_ventas.repository_url}:latest"

      portMappings = [
        {
          containerPort = 8080
        }
      ]

      environment = [
        { name = "DB_ENDPOINT", value = aws_instance.db.private_ip },
        { name = "DB_PORT",     value = "3306" },
        { name = "DB_NAME",     value = "innovatech_db" },
        { name = "DB_USERNAME", value = "innovatech" },
        { name = "DB_PASSWORD", value = "innovatech123" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ventas"
        }
      }
    },
    {
      name  = "despachos-backend"
      image = "${aws_ecr_repository.backend_despachos.repository_url}:latest"

      portMappings = [
        {
          containerPort = 8081
        }
      ]

      environment = [
        { name = "DB_ENDPOINT", value = aws_instance.db.private_ip },
        { name = "DB_PORT",     value = "3306" },
        { name = "DB_NAME",     value = "innovatech_db" },
        { name = "DB_USERNAME", value = "innovatech" },
        { name = "DB_PASSWORD", value = "innovatech123" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "despachos"
        }
      }
    },
    {
      name  = "frontend"
      image = "${aws_ecr_repository.frontend.repository_url}:latest"

      portMappings = [
        {
          containerPort = 80
        }
      ]

      dependsOn = [
        { containerName = "ventas-backend",    condition = "START" },
        { containerName = "despachos-backend", condition = "START" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  force_new_deployment = true

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    subnets          = [aws_subnet.public_frontend.id]
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }
}