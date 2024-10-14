# Define variables for the infrastructure

# AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "eu-west-3"
}

# CIDR block for the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# CIDR block for the public subnet
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

# Availability zone for the public subnet
variable "availability_zone" {
  description = "Availability zone for the public subnet."
  type        = string
  default     = "eu-west-3a"
}

# S3 bucket name
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing images."
  type        = string
  default     = "image-classification-bucket"
}

# SQS queue name
variable "sqs_queue_name" {
  description = "Name of the SQS queue for image processing."
  type        = string
  default     = "image_classification_queue"
}

# Lambda function settings
variable "lambda_function_name" {
  description = "Name of the Lambda function."
  type        = string
  default     = "ImageClassifierLambda"
}

variable "lambda_s3_bucket" {
  description = "S3 bucket where the Lambda function code is stored."
  type        = string
  default     = "your-lambda-code-bucket"
}

variable "lambda_s3_key" {
  description = "S3 key path for the Lambda function code."
  type        = string
  default     = "lambda_function.zip"
}

# EC2 settings
variable "ec2_instance_ami" {
  description = "AMI ID for the EC2 instance."
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Replace with a specific Deep Learning AMI ID
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance."
  type        = string
  default     = "p3.2xlarge"
}

variable "ec2_key_pair" {
  description = "Key pair name for SSH access to the EC2 instance."
  type        = string
  default     = "your-key-pair"  # Replace with your actual key pair
}
