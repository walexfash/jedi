# S3 bucket to upload files
resource "aws_s3_bucket" "uploads" {
  bucket = "jedi-upload-bucket-1"
}

# Upload a file to the bucket
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.uploads.id
  key    = "/temp/jedi.js"
  source = "./jedi.js"

  # The file will be uploaded every time there is a change
  # etag = filemd5("${path.module}/local/path/to/file") 
}

# S3 bucket notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.uploads.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_upload.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
