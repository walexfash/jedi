# Allow public uploads to S3 bucket
resource "aws_s3_bucket_policy" "allow_uploads" {
  bucket = aws_s3_bucket.uploads.id
  policy = jsonencode({
    "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ExampleStmt",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::jedi-upload-bucket-1/*"
      ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::407750740925:role/jedi-role"
        ]
      }
    }
  ]
})
}

# Allow Lambda to encrypt with KMS and write to DynamoDB
resource "aws_iam_role" "lambda" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "jedi-lambda-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:*Object",
          "Resource" : "arn:aws:s3:::jedi-upload-bucket-1"
        }
      ]
    })
  }
}

resource "aws_iam_role_policy" "lambda" {
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "dynamodb:PutItem"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.uploads.arn}/"]
      }
    ]
  })
}

# Allow S3 to invoke lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_upload.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.uploads.arn
}
