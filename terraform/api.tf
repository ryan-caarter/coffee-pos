resource "aws_apigatewayv2_api" "main" {
  name                       = "pos-websocket"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_cloudwatch_log_group" "add" {
  name              = "/aws/apigateway/${aws_apigatewayv2_api.main.id}/production"
  retention_in_days = 30
}

output "post_endpoint" {
  value = aws_apigatewayv2_api.main.api_endpoint
}

