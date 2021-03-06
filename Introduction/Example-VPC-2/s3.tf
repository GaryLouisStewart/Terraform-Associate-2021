resource "aws_s3_bucket" "web_bucket" {
  bucket = local.s3_bucket_name
  acl = "private"
  force_destroy = true

  tags = merge(local.common_tags, { Name = local.s3_bucket_name })
}

resource "aws_s3_bucket_object" "website" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key = "/website/index.html"
  source = "./index.html"
}

resource "aws_s3_bucket_object" "graphics" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key = "/website/Globo_logo_Vert.png"
  source = "./Globo_logo_Vert.png"
}