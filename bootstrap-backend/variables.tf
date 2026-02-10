variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "fastapi-ecs-demo"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = null
}
