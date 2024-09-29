resource "aws_lambda_function" "connect" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${var.service_name}-connect.zip"
  function_name = "${var.service_name}-connect"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "connect.lambda_handler"

  source_code_hash = data.archive_file.connect.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]

  environment {
    variables = {
      CONNECTIONS_TABLE_NAME = var.connections_table_name
      WEBSOCKET_ENDPOINT     = "https://${var.websocket_id}.execute-api.ap-southeast-2.amazonaws.com/production"
      ORDERS_TABLE_NAME      = var.orders_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "connect" {
  name              = "/aws/lambda/${var.service_name}-connect"
  retention_in_days = 30
}

data "archive_file" "connect" {
  type        = "zip"
  source_file = "${path.module}/connect/connect.py"
  output_path = "${var.service_name}-connect.zip"
}

resource "aws_apigatewayv2_integration" "connect" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.connect.invoke_arn
}


resource "aws_apigatewayv2_route" "connect" {
  api_id    = var.api_id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_lambda_permission" "connect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connect.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_arn}/*"
}
