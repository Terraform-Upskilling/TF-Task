# Declare the S3 bucket name variable
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "tf-1-testing-new"  # Default value for the bucket name
}

# IAM Policy allowing read, upload, and download from the specified S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow read, upload, and download from a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",    # Allows downloading objects from S3
          "s3:PutObject",    # Allows uploading objects to S3
          "s3:ListBucket"    # Allows listing objects in the bucket
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/*",   # Allows actions on objects within the bucket
          "arn:aws:s3:::${var.s3_bucket_name}"      # Allows the list operation on the bucket itself
        ]
      }
    ]
  })
}

# IAM Role that can be assumed by a service (like EC2, Lambda, or ECS task)
resource "aws_iam_role" "task_role" {
  name               = "TaskRoleForS3Access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"  # Modify for different services like lambda.amazonaws.com or ecs.amazonaws.com
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Create IAM Instance Profile to associate the role with the EC2 instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "TaskRoleInstanceProfile"
  role = aws_iam_role.task_role.name
}

# Example EC2 instance using the IAM Instance Profile
resource "aws_instance" "abc_instance" {
  ami           = "ami-08b5b3a93ed654d19"  # Replace with an appropriate AMI ID
  instance_type = "t2.micro"

  # Attach the IAM Instance Profile to the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "S3AccessInstance"
  }
}
