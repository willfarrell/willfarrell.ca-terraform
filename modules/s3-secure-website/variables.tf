variable "aws_account_id" {
  type        = "string"
  description = "AWS Account ID"
}

variable "aws_region" {
  type        = "string"
  default     = "us-east-1"
  description = "AWS Region to deploy in"
}

variable "bucket" {
  type        = "string"
  description = "AWS S3 Bucket"
}

variable "cf_aliases" {
  type        = "list"
  description = "Cloudfront Aliases"
}

variable "report_uri_subdomain" {
  type    = "string"
  description = "Subdomain for report-uri.com subdomain to use"
}
