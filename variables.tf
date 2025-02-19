variable "aws_region" {
  description = "AWS Region for S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name"
  type        = string
  default     = "my-unique-s3-bucket-name"
}
