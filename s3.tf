resource "aws_s3_bucket" "bucket" {
  bucket        = local.name_rfc1123
  force_destroy = var.force_destroy
  tags          = merge(local.common_tags, var.extra_tags)
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    object_ownership = var.object_ownership
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
    }
  }

}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.bucket.bucket

  versioning_configuration {
    status = var.versioning
  }

}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  restrict_public_buckets = var.restrict_public_buckets
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
}

resource "aws_s3_bucket_policy" "default_bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = flatten([
      {
        Sid       = "RejectInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "*"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = false
          }
        }
    }, var.bucket_policy_statements])
  })
}
