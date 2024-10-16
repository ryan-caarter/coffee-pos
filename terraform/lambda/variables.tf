variable "service_name" {
  type    = string
  default = "pos"
}

variable "api_id" {
  type = string
}

variable "api_arn" {
  type = string
}

variable "connections_db_arn" {
  type = string
}

variable "connections_table_name" {
  type = string
}

variable "orders_table_name" {
  type = string
}

variable "orders_table_stream_arn" {
  type = string
}

variable "websocket_endpoint" {
  type = string
}

variable "websocket_id" {
  type = string
}

variable "environment" {
  type = string
}
