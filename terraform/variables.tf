variable "aws_region" {
  default = "us-east-1"
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
}
