resource "aws_codebuild_project" "dr_docker1_build1" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "dr_docker1_build1"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild_role.arn
  tags = {
    Environment = var.env
  }

  artifacts {
    
    type                   = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/arjit547/ECS-Docker-2.git"
    git_clone_depth = 1
  }
}