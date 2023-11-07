# DynamoDB table to store encrypted IDs
resource "aws_dynamodb_table" "db" {
  name           = "file-uploads"
  hash_key       = "ID"
  # stream_enabled = true
  read_capacity  = 1
  write_capacity = 1
  # stream_view_type = "NEW_IMAGE"

  attribute {
    name = "ID"
    type = "S"
  }
}