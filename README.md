# Demo Terraform Project

This is a boilerplate Terraform project for a FastAPI application on AWS ECS.

## Project Structure

- `insfrastructures/`: Directory containing all Terraform configuration.
    - `providers.tf`: Terraform and provider configuration.
    - `main.tf`: Main infrastructure resources.
    - `variables.tf`: Input variables.
    - `outputs.tf`: Infrastructure outputs.
- `.gitignore`: Files to be ignored by Git.

## Getting Started

1. Install [Terraform](https://www.terraform.io/downloads.html).
2. Configure your AWS credentials.
3. Change directory to `insfrastructures/`.
4. Run `terraform init` to initialize the project.
5. Run `terraform plan` to see the execution plan.
6. Run `terraform apply` to deploy the infrastructure.
