resource "aws_lambda_function" "add" {
  filename      = "${var.service_name}-add.zip"
  function_name = "${var.service_name}-add"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "add.lambda_handler"

  source_code_hash = data.archive_file.add.output_base64sha256

  runtime       = "python3.12"
  architectures = ["arm64"]

  environment {
    variables = {
      ORDERS_TABLE_NAME = var.orders_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "add" {
  name              = "/aws/lambda/${var.service_name}-add"
  retention_in_days = 30
}


data "archive_file" "add" {
  type        = "zip"
  source_file = "${path.module}/add/add.py"
  output_path = "${var.service_name}-add.zip"
}


resource "aws_apigatewayv2_integration" "add" {
  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.add.invoke_arn
}

resource "aws_apigatewayv2_route" "add" {
  api_id    = var.api_id
  route_key = "add"
  target    = "integrations/${aws_apigatewayv2_integration.add.id}"
}

resource "aws_lambda_permission" "add" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_arn}/*"
}
