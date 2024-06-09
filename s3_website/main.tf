terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 4.0"
}
}
}

# Configure AWS provider and creds
provider "aws" {
region = "us-east-1"
shared_config_files = ["../config.txt"]
shared_credentials_files = ["../credentials.txt"]
profile = "default"
}

# Creating bucket
resource "aws_s3_bucket" "website" {
bucket = "jenkins-bucket-us7d13"

tags = {
Name = "Website"
Environment = "Dev"
}
}

resource "aws_s3_bucket_website_configuration" "website_config" {
bucket = aws_s3_bucket.website.id
index_document {
suffix = "index.html"
}
error_document {
key = "error.html"
}
}

resource "aws_s3_object" "indexfile" {
bucket = aws_s3_bucket.website.id
key = "index.html"
source = "./src/index.html"
content_type = "text/html"
}

output "website_endpoint" {
value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
