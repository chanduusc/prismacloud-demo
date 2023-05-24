resource "aws_s3_bucket" "s3b" {
  # checkov:skip=CKV2_AWS_6: Public access blocks not needed for a demo bucket
  # checkov:skip=CKV_AWS_145: KMS not needed for a demo bucket
  # checkov:skip=CKV_AWS_18: Access logging not deeded for a demo bucket
  # checkov:skip=CKV_AWS_144: Region cross-replication not needed for a demo bucket
  # checkov:skip=CKV_AWS_21: Versioning not needed for a demo bucket
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "pab" {
  # checkov:skip=CKV_AWS_55: Public access ACL needed for demo purposes.
  # checkov:skip=CKV_AWS_54: Public access ACL needed for demo purposes.
  # checkov:skip=CKV_AWS_53: Public access ACL needed for demo purposes.
  bucket = aws_s3_bucket.s3b.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_upload" {
  bucket = aws_s3_bucket.s3b.bucket
  policy = data.aws_iam_policy_document.allow_upload.json
}

data "aws_iam_policy_document" "allow_upload" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    principals {
      type        = "AWS"
      identifiers = [module.eks.eks_managed_node_groups.one.iam_role_arn]
    }
    resources = [
      aws_s3_bucket.s3b.arn,
      "${aws_s3_bucket.s3b.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "object_writer" {
  bucket = aws_s3_bucket.s3b.bucket

  rule {
    object_ownership = "ObjectWriter"
  }
}
