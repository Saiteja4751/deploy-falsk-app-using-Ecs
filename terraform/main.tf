provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "flask_repo" {
  name = var.ecr_repo_name
}
