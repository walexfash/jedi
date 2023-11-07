# jedi
S3 bucket module where manifest file can be uploaded. On upload of a file, that event triggers lambda function which uses a custom kms key to encrypt ID and store it in DynamoDb table.
