output "ecr_repository_url" {
  description = "The URL of the created ECR repository"
  value       = data.aws_ecr_repository.flask_repo.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.flask_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.flask_service.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.flask_task.arn
}
