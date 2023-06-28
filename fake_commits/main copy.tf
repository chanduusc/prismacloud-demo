provider "aws" {
  region     = "us-east-1"
  access_key = "123"
  secret_key = "123"
}

# Hosted zones
resource "aws_route53_zone" "findcovidtestingcom" {
  name = "findcovidtesting.com"
  tags = {
    yor_trace = "352e0b89-7d11-4e2b-8733-5ef620c125c2"
  }
}
resource "aws_route53_zone" "findcovid19testingorg" {
  name = "findcovid19testing.org"
  tags = {
    yor_trace = "8a8d7e18-418c-4677-935f-91c38caee90c"
  }
}
resource "aws_route53_zone" "codersagainstcovidorg" {
  name = "codersagainstcovid.org"
  tags = {
    yor_trace = "bfa5e95a-3658-48e2-9a9d-bdc3b42a97f1"
  }
}

# allows redirect
resource "aws_s3_bucket" "fc19torg" {
  # checkov:skip=CKV2_AWS_6: test
  bucket = "findcovid19testing.org"
  acl    = "private"

  website {

    redirect_all_requests_to = "https://findcovidtesting.com"
  }
  tags = {
    yor_trace = "c2298017-27ee-431b-b683-2890cf376692"
  }
}


resource "aws_s3_bucket" "fc19torg_log_bucket" {
  bucket = "fc19torg-log-bucket"
  tags = {
    yor_trace = "66cca361-5732-40ca-aeb5-6e16890ff390"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "fc19torg_log_bucket" {
  bucket = aws_s3_bucket.fc19torg_log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_logging" "fc19torg" {
  bucket = aws_s3_bucket.fc19torg.id

  target_bucket = aws_s3_bucket.fc19torg_log_bucket.id
  target_prefix = "log/"
}



#######################
# Website stuff
#######################

# Notice the resources were declared once for each environment
# You can keep this DRY with configs and an environment variable like name = "${var.bucket_name}"

# cname www to apex domain
resource "aws_route53_record" "website-www-prod" {
  zone_id = aws_route53_zone.findcovidtestingcom[0].zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "500"
  records = ["codersagainstcovid.org"]
}

# main site to cloudfront
resource "aws_route53_record" "website-cloudfront-prod" {
  zone_id = aws_route53_zone.findcovidtestingcom[0].zone_id
  name    = "codersagainstcovid.org"
  type    = "A"

  alias {
    name                   = "dsad1282321.fakecloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2" # this is static
    evaluate_target_health = false
  }
}
# cname www to apex domain
resource "aws_route53_record" "website-www-staging" {
  zone_id = "1234567"
  name    = "www"
  type    = "CNAME"
  ttl     = "500"
  records = ["staging.codersagainstcovid.org"]
}

# main site to cloudfront
resource "aws_route53_record" "website-cloudfront-staging" {
  zone_id = "1234567"
  name    = "staging.codersagainstcovid.org"
  type    = "A"

  alias {
    name                   = "kqi211282321.fakecloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2" # this is static
    evaluate_target_health = false
  }
}

# Frontend stuff

resource "aws_s3_bucket" "frontend" {
  bucket = "snfisonfwnoi32joi12"
  acl    = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name      = "frontend"
    Terraform = "true"
    yor_trace = "db28d5e3-d2c4-4552-a851-e41bdf31760b"
  }

  region = "us-east-1"

  # TF metadata
  lifecycle {
    prevent_destroy = true
  }
}

# Allow CF OAI to access bucket
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# Policy and user for GH actions to invalidate, upload to s3
data "aws_iam_policy_document" "github" {

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::snfisonfwnoi32joi12/*",

    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::snfisonfwnoi32joi12",

    ]
  }
}

resource "aws_iam_policy" "github" {
  name   = "github_actions"
  path   = "/"
  policy = data.aws_iam_policy_document.github.json
  tags = {
    yor_trace = "405ad507-c01e-4029-8600-a4b2f864afbb"
  }
}

resource "aws_iam_user" "github" {
  name = "github_actions"
  path = "/"
  tags = {
    Terraform = "true"
    yor_trace = "947c7a42-d2fb-45c9-ae29-5f2c6104d508"
  }
}

resource "aws_iam_user_policy_attachment" "github" {
  user       = aws_iam_user.github.name
  policy_arn = aws_iam_policy.github.arn
}


# S3
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["some oai"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.frontend.arn]

    principals {
      type        = "AWS"
      identifiers = ["oai value"]
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "frontend"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = "origin123"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Frontend CF"
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "DELETE", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin123"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin1234"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "100"

  viewer_certificate {
    acm_certificate_arn = "acm-arn-here"
    ssl_support_method  = "sni-only"
  }
  tags = {
    yor_trace = "69e3f4af-3aed-4bec-9a2c-08cdfe419a92"
  }
}