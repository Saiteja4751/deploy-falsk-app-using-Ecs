output "ecr_repo_url" {
  value = aws_ecr_repository.flask_repo.repository_url
}

output "cluster_name" {
  value = aws_ecs_cluster.flask_cluster.name
}

output "task_family" {
  value = aws_ecs_task_definition.flask_task.family
}
