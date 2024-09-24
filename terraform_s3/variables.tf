variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "env" {
  description = "Environment tag for the S3 bucket"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner of the S3 bucket"
  type        = string
  default     = "ajay"
}

variable "versioning_status" {
  description = "Versioning status for the S3 bucket"
  type        = string
  default     = "Enabled"
}
