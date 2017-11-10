variable "aws_account_id" {
  type        = "string"
  description = "AWS Account ID"
}

variable "aws_region" {
  type        = "string"
  description = "AWS Region to deploy in"
}

variable "bucket" {
  type        = "string"
  description = "AWS S3 Bucket"
}
