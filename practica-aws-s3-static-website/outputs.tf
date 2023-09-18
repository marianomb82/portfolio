# Salidas del Bucket S3
output "name" {
  description = "nombre del bucket"
  value       = aws_s3_bucket.my_bucket.bucket
}

output "arn" {
  description = "arn del bucket"
  value       = aws_s3_bucket.my_bucket.arn
}

output "s3_bucket_website_endpoint" {
  description = "endpoint del sitio web"
  value       = aws_s3_bucket.my_bucket.website_endpoint
}