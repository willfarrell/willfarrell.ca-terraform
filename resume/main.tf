# https://github.com/hashicorp/terraform/issues/16611
terraform {
  backend "s3" {
    bucket         = "willfarrell.ca-terraform-state"
    key            = "willfarrell/resume/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    profile        = "willfarrell"
    dynamodb_table = "willfarrell.ca-terraform-state"
  }
}

variable "aws_region" {}
variable "profile" {}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "edge"
  profile = "${var.profile}"
}

data "aws_acm_certificate" "resume" {
  provider = "aws.edge"
  domain   = "resume.willfarrell.ca"
  statuses = [
    "ISSUED"]
}

module "resume" {
  source              = "git@github.com:tesera/terraform-modules//public-static-assets"
  name                = "resume-willfarrell-ca"
  aliases             = [
    "resume.willfarrell.ca"]
  acm_certificate_arn = "${data.aws_acm_certificate.resume.arn}"
  lambda_viewer_response = "${file("${path.module}/viewer-response.js")}"
}

