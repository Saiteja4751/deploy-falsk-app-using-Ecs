output "ecr_repository_url" {
  description = "The URL of the created ECR repository"
  value       = aws_ecr_repository.flask_repo.repository_url
}
