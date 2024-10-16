terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

resource "aws_api_gateway_usage_plan" "main" {
  name        = "${var.service_name}-usage-plan"
  description = "Usage plan for POS Websocket"

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }

  api_stages {
    api_id = var.api_id
    stage  = aws_apigatewayv2_stage.main.id
  }

  quota_settings {
    limit  = 500
    period = "DAY"
  }
}

resource "aws_apigatewayv2_stage" "main" {
  depends_on  = [aws_api_gateway_account.main]
  auto_deploy = true
  api_id      = var.api_id
  name        = "production"

  route_settings {
    route_key              = "$connect"
    logging_level          = "INFO"
    throttling_burst_limit = 5
    throttling_rate_limit  = 10
  }

  route_settings {
    route_key              = "$disconnect"
    logging_level          = "INFO"
    throttling_burst_limit = 5
    throttling_rate_limit  = 10
  }

  # route_settings {
  #   route_key              = "update"
  #   logging_level          = "INFO"
  #   throttling_burst_limit = 5
  #   throttling_rate_limit  = 10
  # }

  default_route_settings {
    logging_level          = "INFO"
    throttling_burst_limit = 5
    throttling_rate_limit  = 10
  }
}

output "stage" {
  value = aws_apigatewayv2_stage.main.name
}
