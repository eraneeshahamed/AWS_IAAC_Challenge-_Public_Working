resource "aws_s3_bucket" "news" {
  bucket = "${var.prefix}-terraform-infra-static-pages"
  acl    = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "news" {
  bucket = "${aws_s3_bucket.news.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
