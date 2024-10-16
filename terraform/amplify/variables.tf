variable "websocket_endpoint" {
  type = string
}

variable "stage" {
  type = string
}

variable "access_token" {
  type      = string
  sensitive = true
}

variable "environment" {
  type = string
}
