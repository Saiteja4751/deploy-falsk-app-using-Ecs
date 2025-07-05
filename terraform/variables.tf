variable "aws_region" {}
variable "ecr_repo_name" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "ecs_task_family" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
