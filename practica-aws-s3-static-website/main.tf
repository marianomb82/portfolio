# Declaración de un Bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket
}

#Quitar bloqueo public access
resource "aws_s3_bucket_public_access_block" "my_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Configuración de sitio web estático
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#Configuración de la bucket policy del S3
resource "aws_s3_bucket_policy" "my_bucket_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket}/*"
        }
    ]
}
POLICY
}

# Subida de ficheros al bucket 
resource "aws_s3_object" "fichero_index" {

  bucket      = aws_s3_bucket.my_bucket.id
  key         = "index.html"
  source      = "index.html"
  source_hash = filemd5("index.html")

  content_type = "text/html"
}

resource "aws_s3_object" "fichero_error" {

  bucket      = aws_s3_bucket.my_bucket.id
  key         = "error.html"
  source      = "error.html"
  source_hash = filemd5("error.html")

  content_type = "text/html"
}

resource "aws_s3_object" "jpg_index" {

  bucket      = aws_s3_bucket.my_bucket.id
  key         = "different-languages.jpg"
  source      = "different-languages.jpg"
  source_hash = filemd5("different-languages.jpg")

  content_type = "image/jpeg"
}

resource "aws_s3_object" "jpg_error" {

  bucket      = aws_s3_bucket.my_bucket.id
  key         = "Acceso-bloqueado.jpg"
  source      = "Acceso-bloqueado.jpg"
  source_hash = filemd5("Acceso-bloqueado.jpg")

  content_type = "image/jpeg"
}

