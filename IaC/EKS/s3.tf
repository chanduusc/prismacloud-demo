resource "aws_s3_bucket" "s3b" {
  # checkov:skip=CKV_AWS_18: Access logging not deeded for a demo bucket
  # checkov:skip=CKV_AWS_144: Region cross-replication not needed for a demo bucket
  # checkov:skip=CKV_AWS_21: Versioning not needed for a demo bucket
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3b" {
  bucket = aws_s3_bucket.s3b.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket = aws_s3_bucket.s3b.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
