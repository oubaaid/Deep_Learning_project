# Define the provider and region
provider "aws" {
  region = "eu-west-3"
}

# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}

# Define a public subnet within the VPC
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "InternetGateway"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Define an S3 bucket for storing images
resource "aws_s3_bucket" "image_classification" {
  bucket = "image-classification-bucket"
}

# Define an SQS queue for message processing
resource "aws_sqs_queue" "image_classification_queue" {
  name = "image_classification_queue"
}

# Define IAM Role for Lambda function with necessary permissions
resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "s3_readonly_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "sqs_fullaccess_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# Define a Lambda function to process images
resource "aws_lambda_function" "image_classifier" {
  function_name = "ImageClassifierLambda"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_execution_role.arn
  s3_bucket     = "your-lambda-code-bucket"  # Update with actual bucket name where the Lambda code is stored
  s3_key        = "lambda_function.zip"      # Update with the path to your Lambda zip file
  runtime       = "python3.9"

  environment {
    variables = {
      SQS_QUEUE_URL   = aws_sqs_queue.image_classification_queue.id
      S3_BUCKET_NAME  = aws_s3_bucket.image_classification.bucket
    }
  }

  timeout = 60
}

# Configure S3 bucket to trigger the Lambda function on object creation events
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_classification.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_classifier.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_function.image_classifier]
}

# Define an EC2 instance for image classification processing
resource "aws_instance" "image_classification_ec2" {
  ami                         = "ami-0c55b159cbfafe1f0"  # Update with actual Deep Learning AMI ID for eu-west-3
  instance_type               = "p3.2xlarge"
  subnet_id                   = aws_subnet.public.id
  key_name                    = "your-key-pair"  # Update with your EC2 Key Pair
  associate_public_ip_address = true

  user_data = base64encode(
    <<-EOF
      #!/bin/bash
      aws s3 cp s3://image-classification-bucket/model /home/ec2-user/model
      python3 /home/ec2-user/classify_images.py
    EOF
  )

  tags = {
    Name = "ImageClassificationEC2"
  }
}

# Output the public IP address of the EC2 instance
output "EC2InstancePublicIP" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.image_classification_ec2.public_ip
}
