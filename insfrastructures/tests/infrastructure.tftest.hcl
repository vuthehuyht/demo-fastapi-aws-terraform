# Comprehensive Test Suite for FastAPI AWS Infrastructure

# 1. VPC & Networking Validation
run "validate_networking" {
  command = plan

  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR block must be 10.0.0.0/16"
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "There should be exactly 2 public subnets"
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "There should be exactly 2 private subnets"
  }
}

# 2. Security Group Rule Validation
run "validate_security_groups" {
  command = plan

  # ALB SG should allow HTTP 80 from anywhere
  assert {
    condition     = anytrue([for r in aws_security_group.alb.ingress : r.from_port == 80 && r.to_port == 80])
    error_message = "ALB must allow inbound traffic on port 80"
  }

  # ECS Tasks SG should permit traffic from ALB
  assert {
    condition     = aws_security_group_rule.ecs_ingress_alb.from_port == 8000
    error_message = "ECS Tasks must allow inbound traffic on port 8000"
  }
}

# 3. IAM & ECR Validation
run "validate_permissions_and_registry" {
  command = plan

  assert {
    condition     = can(regex("ecs-tasks.amazonaws.com", aws_iam_role.ecs_task_execution_role.assume_role_policy))
    error_message = "IAM Role must have ecs-tasks.amazonaws.com in trust policy"
  }

  assert {
    condition     = aws_ecr_repository.app.image_scanning_configuration[0].scan_on_push == true
    error_message = "ECR Repository must have scan_on_push enabled for security"
  }
}

# 4. ALB & Target Group Validation
run "validate_load_balancer" {
  command = plan

  assert {
    condition     = aws_lb.main.load_balancer_type == "application"
    error_message = "Load Balancer must be an Application Load Balancer"
  }

  assert {
    condition     = aws_lb_target_group.app.target_type == "ip"
    error_message = "Target Group type must be 'ip' for Fargate support"
  }

  assert {
    condition     = aws_lb_target_group.app.health_check[0].path == "/health"
    error_message = "Target Group health check path must be '/health'"
  }
}

# 5. ECS Task & Service Validation
run "validate_ecs_configuration" {
  command = plan

  assert {
    condition     = contains(aws_ecs_task_definition.app.requires_compatibilities, "FARGATE")
    error_message = "ECS Task must use FARGATE compatibility"
  }

  assert {
    condition     = aws_ecs_service.app.deployment_minimum_healthy_percent == 100
    error_message = "ECS Service must have minimum_healthy_percent set to 100"
  }

  assert {
    condition     = aws_ecs_service.app.deployment_maximum_percent == 200
    error_message = "ECS Service must have maximum_percent set to 200"
  }
}

# 6. Monitoring & Scaling Validation
run "validate_monitoring_and_scaling" {
  command = plan

  assert {
    condition     = aws_cloudwatch_metric_alarm.ecs_cpu_high.threshold == 80
    error_message = "ECS CPU alarm threshold should be 80%"
  }

  assert {
    condition     = aws_appautoscaling_target.ecs_target.max_capacity == 5
    error_message = "Auto Scaling max capacity should be 5"
  }

  assert {
    condition     = aws_appautoscaling_target.ecs_target.min_capacity == 1
    error_message = "Auto Scaling min capacity should be 1"
  }
}
