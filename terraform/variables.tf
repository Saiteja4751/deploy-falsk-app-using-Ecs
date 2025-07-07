variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "ecr_repo_name" {
  description = "ECR Repository Name"
  type        = string
}

variable "ecs_cluster_name" {
  default = "flask-cluster"
}

variable "ecr_image_uri" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}