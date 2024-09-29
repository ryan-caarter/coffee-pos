resource "aws_lambda_function" "complete" {
  filename      = "${var.service_name}-complete.zip"
  function_name = "${var.service_name}-complete"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "complete.lambda_handler"

  source_code_hash = data.archive_file.complete.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]

  environment {
    variables = {
      ORDERS_TABLE_NAME = var.orders_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "complete" {
  name              = "/aws/lambda/${var.service_name}-complete"
  retention_in_days = 30
}


data "archive_file" "complete" {
  type        = "zip"
  source_file = "${path.module}/complete/complete.py"
  output_path = "${var.service_name}-complete.zip"
}


resource "aws_apigatewayv2_integration" "complete" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.complete.invoke_arn
}

resource "aws_apigatewayv2_route" "complete" {
  api_id    = var.api_id
  route_key = "complete"
  target    = "integrations/${aws_apigatewayv2_integration.complete.id}"
}

resource "aws_lambda_permission" "complete" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.complete.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_arn}/*"
}
