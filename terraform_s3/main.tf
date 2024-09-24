
resource "aws_s3_bucket" "s3_for_tfstate" {
  bucket = var.bucket_name  # Replace with a unique bucket name

  tags = {
    env   = var.env
    owner = var.owner
  }
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.s3_for_tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}
