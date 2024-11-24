resource "aws_dynamodb_table" "orders" {
  name             = "OrderQueue"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "order_id"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "order_id"
    type = "S"
  }

  attribute {
    name = "customer_name"
    type = "S"
  }
   
  attribute {
    name = "pastry"
    type = "S"
  }

  attribute {
    name = "item"
    type = "S"
  }

  attribute {
    name = "extra_note"
    type = "S"
  }

  attribute {
    name = "milk_type"
    type = "S"
  }

  attribute {
    name = "time"
    type = "S"
  }

  global_secondary_index {
    name            = "order_id_index"
    hash_key        = "order_id"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "item_index"
    hash_key        = "item"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "customer_name_index"
    hash_key        = "customer_name"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "pastry_index"
    hash_key        = "pastry"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "extra_note_index"
    hash_key        = "extra_note"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "milk_type_index"
    hash_key        = "milk_type"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "time_index"
    hash_key        = "time"
    projection_type = "ALL"
  }
}
resource "aws_dynamodb_table" "connections" {
  name         = "ConnectionsTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connectionId"


  attribute {
    name = "connectionId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  ttl {
    attribute_name = "timeToLive"
    enabled        = true
  }

  global_secondary_index {
    name            = "connectionId"
    hash_key        = "connectionId"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "userId"
    hash_key        = "userId"
    projection_type = "ALL"
  }
}

output "connections_db_arn" {
  value = aws_dynamodb_table.connections.arn
}
