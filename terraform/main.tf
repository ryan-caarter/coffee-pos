terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "lambda" {
  source                  = "./lambda"
  api_id                  = aws_apigatewayv2_api.main.id
  api_arn                 = aws_apigatewayv2_api.main.execution_arn
  connections_db_arn      = aws_dynamodb_table.connections.arn
  connections_table_name  = aws_dynamodb_table.connections.name
  orders_table_name       = aws_dynamodb_table.orders.name
  websocket_endpoint      = aws_apigatewayv2_api.main.api_endpoint
  orders_table_stream_arn = aws_dynamodb_table.orders.stream_arn
  websocket_id            = aws_apigatewayv2_api.main.id
}

module "amplify" {
  source                  = "./amplify"
  websocket_endpoint = aws_apigatewayv2_api.main.api_endpoint
  stage = module.lambda.stage
}
