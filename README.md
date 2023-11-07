**# jedi**

**Introduction**

The objective is to locate and safeguard the location of the Jedi identified in the mission while keeping their identity secret.

My approach is to create a module with S3 bucket where manifest file can be uploaded. On upload of a file, that event triggers lambda function which uses a custom kms key to encrypt ID and store it in DynamoDb table. I took this approach because it will be an event-driven architecture, serverless and cost-effective. 

1. Create Provider file.
   
<img width="330" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/ce54fe23-f010-40ce-b729-131f6b828728">

2. Create S3 bucket, create Lambda function, create IAM roles and policies and create KMS key files.
   

<img width="149" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/ee72a16c-82a2-4f10-9f9a-246c48f6fe0b">

3. Results

S3 Bucket created

<img width="654" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/be0cd87e-73b8-4397-8359-70d1a94ce5a2">


Jedi file uploaded

<img width="682" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/ef6f1ba5-d6df-402d-bf68-ca2b8beea2b0">

Lambder Function created

<img width="658" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/37043e0b-ad61-46b9-9c67-f80ad31db944">

Dynamodb created

<img width="659" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/510e39fd-206e-4668-8fe5-f11dd30fe605">

IAM role created

<img width="650" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/8b40724e-f9da-45fc-b6bd-d14c6ba99de8">

KMS key created

<img width="395" alt="image" src="https://github.com/walexfash/jedi/assets/35840406/141f5173-df11-4d9f-8a67-71d17e3bddca">

**Note**

I couldn't hide the IDs as I getting error whilst trying to implement this part. 





