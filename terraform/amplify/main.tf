terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

locals {
  stage = {"test": "DEVELOPMENT", "uat": "BETA", "production": "PRODUCTION", }
}

resource "aws_amplify_app" "main" {
  name       = "coffee pos ${var.environment}"
  repository = "https://github.com/ryan-caarter/coffee-pos"

  enable_branch_auto_deletion = true

  build_spec = <<-EOT
    version: 1
    frontend:
        phases:
            preBuild:
                commands:
                    - npm ci --cache .npm --prefer-offline
            build:
                commands:
                    - npm run build
        artifacts:
            baseDirectory: build
            files:
                - '**/*'
        cache:
            paths:
                - .npm/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  access_token = var.access_token


  environment_variables = {
    REACT_APP_WEBSOCKET_ENDPOINT = var.websocket_endpoint
    REACT_APP_STAGE              = var.stage
  }
}

resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.main.id
  branch_name       = "main"
  enable_auto_build = true
  framework         = "React"
  stage             = local.stage[var.environment]

  environment_variables = {
    REACT_APP_WEBSOCKET_ENDPOINT = var.websocket_endpoint
    REACT_APP_STAGE              = var.stage
  }
}

output "app_url" {
  value = "https://main.${aws_amplify_app.main.default_domain}"
}
