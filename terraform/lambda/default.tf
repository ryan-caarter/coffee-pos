resource "aws_lambda_function" "default" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${var.service_name}-default.zip"
  function_name = "${var.service_name}-default"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "default.lambda_handler"

  source_code_hash = data.archive_file.default.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]

  environment {
    variables = {
      CONNECTIONS_TABLE_NAME = var.connections_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${var.service_name}-default"
  retention_in_days = 30
}


data "archive_file" "default" {
  type        = "zip"
  source_file = "${path.module}/default/default.py"
  output_path = "${var.service_name}-default.zip"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.default.invoke_arn
}


resource "aws_apigatewayv2_route" "default" {
  api_id    = var.api_id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_lambda_permission" "default" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_arn}/*"
}
