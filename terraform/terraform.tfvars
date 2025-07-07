aws_region     = "us-east-1"
ecr_repo_name  = "flask-ecr-app"



ecs_cluster_name = "flask-cluster"
aws_region       = "us-east-1"

# Replace these with your actual values
subnet_ids        = ["subnet-0540937d860abb34e", "subnet-0b6fa121406a06f42"]
security_group_id = "sg-01aade2d4b303d990"
ecr_image_uri     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/flask-ecr-app:latest"