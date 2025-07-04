variable "app_name" {
  default = "flask-ecs-app"
}

variable "security_group_name" {
  default = "flask-ecs-app-sg"
}


variable "iam_role_name" {
  default = "flask-ecs-app-ecs-task-execution"
}
 