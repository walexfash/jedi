****Jedi****

**Introduction**

The objective is to locate and safeguard the location of the Jedi identified in the mission while keeping their identity secret.

My approach is to create a module with S3 bucket where manifest file can be uploaded. On upload of a file, that event triggers lambda function which uses a custom kms key to encrypt ID and store it in DynamoDb table. I took this approach because it will be an event-driven architecture, serverless and cost-effective. 

<img width="427" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/0c6b81c0-e86a-48c8-999c-fbfe3414cfd0">


This Terraform module aims to simplify all operations when working with the serverless in Terraform:

- Create Provider (provider.tf) file that contains AWS as provider, region, access key and secret key.
- Create S3 bucket (s3.tf) specifying resources such as bucket name, object and bucket notification.
- Create Lambda function (lambda.tf) that will be triggered by S3 uploads.
- Create KMS resource.
- Create Dynamodb resource.
- Create IAM (iam.tf) that will contains Policies and roles.
- Create jedi.zip, add jedi.json file.

**Usage**

1. Create Provider file.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  # Configuration options
  
  region ="eu-west-2"
  access_key = "xxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxx"
}
   
<img width="330" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/ce54fe23-f010-40ce-b729-131f6b828728">

2. Create S3 bucket name, object and bucket notification.

# S3 bucket to upload files

resource "aws_s3_bucket" "uploads" {
  bucket = "jedi-upload-bucket-1"
}

# Upload a file to the bucket

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.uploads.id
  key    = "/temp/jedi.js"
  source = "./jedi.js"
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


3. Create Lambda function (lambda.tf) that will be triggered by S3 uploads.

# Lambda function triggered by S3 uploads 

resource "aws_lambda_function" "process_upload" {
  filename      = "jedi.zip"
  function_name = "process_upload"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "python3.7"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.db.name
      AWS_ENCRYPTION_SDK_KEY_PROVIDER = "aws-kms"
      AWS_KMS_KEY_ID                  = aws_kms_key.jedi_key.key_id
    }
  }
}

4. Create KMS resource.

# Create KMS key

resource "aws_kms_key" "jedi_key" {
  description             = "Jedi KMS key"
  deletion_window_in_days = 7
}

5. Create Dynamodb resource.

# DynamoDB table to store encrypted IDs

resource "aws_dynamodb_table" "db" {
  name           = "file-uploads"
  hash_key       = "ID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "ID"
    type = "S"
  }
}

6. Create IAM (iam.tf) that will contains Policies and roles. This is the process of setting up permissions for S3 bucket, Lambda, Dynamodb .

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

   
7. Create jedi.zip, add jedi.json file.

add a zip jedi.json to the terraform module and add the (jedi.json) file containing the names
and locations of strong Jedi.

**Output**

- S3 Bucket created

<img width="654" alt="Screenshot 2023-11-06 005215" src="https://github.com/walexfash/jedi/assets/35840406/2954f3a7-3e02-4502-af44-4538bcf8d9d2">


- Jedi file uploaded

<img width="682" alt="Screenshot 2023-11-06 010051" src="https://github.com/walexfash/jedi/assets/35840406/7c044d4e-27eb-43e4-bcdf-0b9ffff0728a">



- Lambder Function created

<img width="658" alt="Screenshot 2023-11-06 005339" src="https://github.com/walexfash/jedi/assets/35840406/41a5c90a-3bc0-465b-b6bd-fe0a889532db">



- Dynamodb created

<img width="660" alt="Screenshot 2023-11-06 005428" src="https://github.com/walexfash/jedi/assets/35840406/1f0b009c-759b-410f-956d-19e444ebc646">


- KMS key created.
   

<img width="396" alt="Screenshot 2023-11-06 005853" src="https://github.com/walexfash/jedi/assets/35840406/73c1f0b2-0bc2-4b4d-b39b-238e3f5592f3">


IAM role created

<img width="650" alt="Screenshot 2023-11-06 005555" src="https://github.com/walexfash/jedi/assets/35840406/ea564afe-2be0-448e-91d2-0b77d1b6b8ab">



**Note**

I couldn't hide the IDs as I getting error whilst trying to implement this part. 
