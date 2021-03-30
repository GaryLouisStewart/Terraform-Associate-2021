resource "aws_s3_bucket" "web_bucket" {
  tags = merge(local.common_tags, { Name = local.s3_bucket_name })
}