variable "app_name" {
  description = "Name of the Flask ECS application"
  default     = "flask-ecs-app"
}

variable "iam_role_name" {
  description = "IAM role name for ECS task execution"
  default     = "flask-ecs-app-ecs-task-execution"
}
