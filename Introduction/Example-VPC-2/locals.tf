resource "random_uuid" "s3_prefix" {}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals{
  name_prefix = random_uuid.s3_prefix.result
  common_tags = {
    environment = var.environment
    service = var.service
    Terraformed = true
  }
  s3_bucket_name = "${local.name_prefix}-${var.environment}-${random_integer.rand.result}"
}
