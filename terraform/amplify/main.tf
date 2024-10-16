terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

variable "websocket_endpoint" {
  type = string
}

variable "stage" {
    type = string
}

resource "aws_amplify_app" "example" {
  name       = "coffee pos"
  repository = "https://github.com/ryan-caarter/coffee-pos"

  # The default build_spec added by the Amplify Console for React.
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

  environment_variables = {
    WEBSOCKET_ENDPOINT = var.websocket_endpoint
    STAGE = var.stage
  }
}