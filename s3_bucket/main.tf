resource "aws_s3_bucket" "bucket_for_tfstate" {
  bucket = var.bucket_name
  versioning {
    enabled = true
  }

  tags = {
    Name = "TerraformState"
  }
}