terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote Backend: State is stored in S3 and locked via DynamoDB.
  # Pre-requisite: Run terraform in the 'bootstrap-backend' directory first.
  backend "s3" {
    bucket         = "fastapi-ecs-demo-terraform-state-654654329682"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "fastapi-ecs-demo-terraform-locks"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
