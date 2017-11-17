# https://github.com/hashicorp/terraform/issues/16611
terraform {
  backend "s3" {
    bucket         = "willfarrell.ca-terraform-state"
    key            = "app/test/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    profile        = "willfarrell"
    dynamodb_table = "willfarrell.ca-terraform-state"
  }
}

variable "aws_account_id" {}
variable "aws_region" {}
variable "aws_profile" {}

provider "aws" {
  region = "${var.aws_region}"
  profile = "willfarrell"
}

provider "aws" {
  # For Edge API Gateway
  region = "us-east-1"
  alias = "edge"
  profile = "willfarrell"
}

module "s3_test_website" {
  source = "../modules/s3-secure-website"
  aws_account_id = "${var.aws_account_id}"
  aws_region = "${var.aws_region}"
  bucket = "test-willfarrell-ca-website"
  cf_aliases = ["test.willfarrell.ca"]

  report_uri_subdomain = "willfarrell"
}
