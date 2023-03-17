resource "aws_ecs_cluster" "ecs" {
  name = "app_cluster"
}

resource "aws_ecs_service" "webapp_service" {
  name = "webapp_service"
  cluster                = aws_ecs_cluster.ecs.arn
  launch_type            = "FARGATE"
  enable_execute_command = true

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.td.arn

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.security_group.id]
    subnets          = [aws_subnet.subnet1.id]
  }
}

resource "aws_ecs_task_definition" "td" {
  container_definitions = jsonencode([
    {
      name         = "webapp"
      image        = "103230870745.dkr.ecr.us-east-1.amazonaws.com/webapp_repo"
      cpu          = 256
      memory       = 512
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  family                   = "webapp"
  requires_compatibilities = ["FARGATE"]

  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
  task_role_arn      = "arn:aws:iam::103230870745:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::103230870745:role/ecsTaskExecutionRole"
}
