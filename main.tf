# Create an S3 Bucket
resource "aws_s3_bucket" "tf-testing-news3-bucket-unique-name" {
  bucket = var.bucket_name
}

# Set bucket ownership controls (optional but recommended)
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.tf-testing-news3-bucket-unique-name.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Apply Public ACL settings (disable if bucket should be private)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.tf-testing-news3-bucket-unique-name.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload a file to S3 bucket
resource "aws_s3_object" "upload_file" {
  bucket = aws_s3_bucket.tf-testing-news3-bucket-unique-name.id
  key    = "uploaded-file.txt"  # S3 object key (filename)
  source = "local-file.txt"     # Local file to upload
  acl    = "public-read"        # Change to "private" if needed
}


