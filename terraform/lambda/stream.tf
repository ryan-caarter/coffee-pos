resource "aws_lambda_function" "stream" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${var.service_name}-stream.zip"
  function_name = "${var.service_name}-stream"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "stream.lambda_handler"

  source_code_hash = data.archive_file.stream.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]

  environment {
    variables = {
      ORDERS_TABLE_NAME      = var.orders_table_name
      WEBSOCKET_ENDPOINT     = "https://${var.websocket_id}.execute-api.ap-southeast-2.amazonaws.com/production"
      CONNECTIONS_TABLE_NAME = var.connections_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "stream" {
  name              = "/aws/lambda/${var.service_name}-stream"
  retention_in_days = 30
}

data "archive_file" "stream" {
  type        = "zip"
  source_file = "${path.module}/stream/stream.py"
  output_path = "${var.service_name}-stream.zip"
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = var.orders_table_stream_arn
  function_name     = aws_lambda_function.stream.arn
  starting_position = "LATEST"
}


# resource "aws_apigatewayv2_integration" "stream" {
#   api_id           = var.api_id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.stream.invoke_arn
# }

# resource "aws_apigatewayv2_route" "stream" {
#   api_id    = var.api_id
#   route_key = "stream"
#   target    = "integrations/${aws_apigatewayv2_integration.stream.id}"
# }

# resource "aws_lambda_permission" "stream" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.stream.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${var.api_arn}/*"
# }
