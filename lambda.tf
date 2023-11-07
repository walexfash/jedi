# Lambda function triggered by S3 uploads 
resource "aws_lambda_function" "process_upload" {
  filename      = "jedi.zip"
  function_name = "process_upload"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "python3.8"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.db.name
      AWS_ENCRYPTION_SDK_KEY_PROVIDER = "aws-kms"
      AWS_KMS_KEY_ID                  = aws_kms_key.jedi_key.key_id
    }
  }
}
