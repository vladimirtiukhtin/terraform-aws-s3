output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "read_only_policy_arn" {
  value = aws_iam_policy.bucket_read_only_policy.arn
}

output "read_write_policy_arn" {
  value = aws_iam_policy.bucket_read_write_policy.arn
}
