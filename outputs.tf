# Outputs for the infrastructure

# Public IP of the EC2 instance
output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.image_classification_ec2.public_ip
}

# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Public Subnet ID
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# Internet Gateway ID
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# S3 Bucket Name
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.image_classification.bucket
}

# SQS Queue URL
output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.image_classification_queue.id
}

# Lambda Function Name
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.image_classifier.function_name
}

# EC2 Instance ID
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.image_classification_ec2.id
}
