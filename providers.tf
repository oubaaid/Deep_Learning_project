# Define the AWS provider and region
provider "aws" {
  region = var.aws_region
}

# Specify the required provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}
