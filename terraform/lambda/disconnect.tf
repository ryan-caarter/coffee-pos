resource "aws_lambda_function" "disconnect" {
  filename      = "${var.service_name}-disconnect.zip"
  function_name = "${var.service_name}-disconnect"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "disconnect.lambda_handler"

  source_code_hash = data.archive_file.disconnect.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]

  environment {
    variables = {
      CONNECTIONS_TABLE_NAME = var.connections_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "disconnect" {
  name              = "/aws/lambda/${var.service_name}-disconnect"
  retention_in_days = 30
}

data "archive_file" "disconnect" {
  type        = "zip"
  source_file = "${path.module}/disconnect/disconnect.py"
  output_path = "${var.service_name}-disconnect.zip"
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.disconnect.invoke_arn
}


resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = var.api_id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_lambda_permission" "disconnect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.disconnect.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_arn}/*"
}
