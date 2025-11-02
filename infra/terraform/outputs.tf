output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "pipeline_name" {
  value = aws_codepipeline.this.name
}

output "artifact_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

