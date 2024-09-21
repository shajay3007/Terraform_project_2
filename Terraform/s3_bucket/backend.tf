terraform {
  backend "s3" {
    bucket = "ajay-shakapuram-tf-automation"
    key = "ekss3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "my-dynamodb-table"
  }
}
