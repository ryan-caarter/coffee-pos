resource "aws_lambda_function" "stream" {
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
      WEBSOCKET_ENDPOINT     = "https://${var.websocket_id}.execute-api.ap-southeast-2.amazonaws.com/${aws_apigatewayv2_stage.main.name}"
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
