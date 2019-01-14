resource "aws_s3_bucket" "s3_static_website" {
  bucket = "${var.bucket}"
  region = "${var.aws_region}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.s3_static_website_policy.json}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["${var.bucket}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  versioning {
    enabled = true
  }

  //acceleration_status = "Enabled"
}


data "aws_iam_policy_document" "s3_static_website_policy" {
  statement {
    actions   = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket}",
      "arn:aws:s3:::${var.bucket}/*"
    ]
    principals = {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}

