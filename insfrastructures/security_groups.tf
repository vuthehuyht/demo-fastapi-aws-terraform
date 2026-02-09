# Security Group governing firewall rules for ECS tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Allow inbound access for ECS tasks"
  vpc_id      = aws_vpc.main.id

  # Allow inbound traffic on the container's application port
  ingress {
    protocol    = "tcp"
    from_port   = var.container_port
    to_port     = var.container_port
    cidr_blocks = ["0.0.0.0/0"] # Should be restricted if using a Load Balancer
  }

  # Allow all outbound traffic to the internet (e.g., to pull images, call external APIs)
  egress {
    protocol    = "any"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}
