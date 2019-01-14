# https://github.com/hashicorp/terraform/issues/16611
terraform {
  backend "s3" {
    bucket         = "willfarrell.ca-terraform-state"
    key            = "willfarrell/www/terraform.tfstate"
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

data "aws_acm_certificate" "www" {
  provider = "aws.edge"
  domain   = "www.willfarrell.ca"
  statuses = [
    "ISSUED"]
}

module "www" {
  source              = "git@github.com:tesera/terraform-modules//public-static-assets"
  name                = "willfarrell-ca"
  aliases             = [
    "www.willfarrell.ca", "willfarrell.ca"]
  acm_certificate_arn = "${data.aws_acm_certificate.www.arn}"
  lambda_edge_content = "${file("${path.module}/edge.js")}"
}

//data "aws_acm_certificate" "www-redirect" {
//  provider = "aws.edge"
//  domain   = "willfarrell.ca"
//  statuses = [
//    "ISSUED"]
//}
//
//module "www-redirect" {
//  source              = "git@github.com:tesera/terraform-modules//public-redirect"
//  name                = "willfarrell-ca"
//  aliases             = [
//    "willfarrell.ca"]
//  redirect            = "www.willfarrell.ca"
//  acm_certificate_arn = "${data.aws_acm_certificate.www-redirect.arn}"
//}


output "bucket" {
  value = "${module.www.bucket}"
}
