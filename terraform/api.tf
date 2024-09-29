resource "aws_apigatewayv2_api" "main" {
  name                       = "pos-websocket"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

output "post_endpoint" {
  value = aws_apigatewayv2_api.main.api_endpoint
}

