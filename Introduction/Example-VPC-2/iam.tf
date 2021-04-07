resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
       Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
       Effect = "Allow"
       Sid = ""
      }
    ]
  })
  tags = merge(local.common_tags, { Name: "${var.environment}-s3bucket" }) 
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx-profile"
  role = aws_iam_role.allow_nginx_s3.name
}


resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
       ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF
}