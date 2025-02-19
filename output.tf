
output "bucket_name" {
  value = aws_s3_bucket.tf-testing-news3-bucket-unique-name.id
}

output "file_url" {
  value = "https://${aws_s3_bucket.tf-testing-news3-bucket-unique-name.bucket}.s3.amazonaws.com/${aws_s3_object.upload_file.key}"
}
