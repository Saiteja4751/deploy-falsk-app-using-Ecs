variable "app_name" {
  type    = string
  default = "flask-ecs-app"
}

variable "iam_role_name" {
  type    = string
  default = "flask-ecs-app-ecs-task-execution"
}
