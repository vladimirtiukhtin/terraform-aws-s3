resource "aws_iam_policy" "bucket_read_write_policy" {
  name = substr("${join("", [for word in regexall("[a-zA-Z0-9+=,.@-_]*", var.name) : title(word)])}BucketReadWrite", 0, 128)
  path = "/"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = concat(
        [
          {
            Sid    = "AllowBucketListing"
            Effect = "Allow"
            Action = [
              "s3:ListBucket",
              "s3:GetBucketLocation"
            ]
            Resource = aws_s3_bucket.bucket.arn
          },
          {
            Sid    = "AllowGetPutDeleteObject"
            Effect = "Allow"
            Action = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
            ]
            Resource = "${aws_s3_bucket.bucket.arn}/*"
          }
        ],
        var.kms_key_arn != null ? [
          {
            Sid    = "AllowKMSAccess"
            Effect = "Allow"
            Action = [
              "kms:GenerateDataKey",
              "kms:Decrypt"
            ]
            Resource = var.kms_key_arn
          }
        ] : []
      )
    }
  )
  tags = local.common_tags
}

resource "aws_iam_policy" "bucket_read_only_policy" {
  name = substr("${join("", [for word in regexall("[a-zA-Z0-9+=,.@-_]*", var.name) : title(word)])}BucketReadOnly", 0, 128)
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : concat(
        [
          {
            Sid    = "AllowBucketListing"
            Effect = "Allow"
            Action = [
              "s3:ListBucket",
              "s3:GetBucketLocation"
            ],
            Resource = aws_s3_bucket.bucket.arn
          },
          {
            Sid    = "AllowGetPutDeleteObject"
            Effect = "Allow"
            Action = [
              "s3:GetObject"
            ]
            Resource = "${aws_s3_bucket.bucket.arn}/*"
          }
        ],
        var.kms_key_arn != null ? [
          {
            Sid    = "AllowKMSAccess"
            Effect = "Allow"
            Action = [
              "kms:Decrypt"
            ]
            Resource = var.kms_key_arn
          }
        ] : []
      )
    }
  )
  tags = local.common_tags
}
