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

provider "aws" {
  region  = local.workspace["region"]
  profile = local.workspace["profile"]
}

provider "aws" {
  region  = "us-east-1"
  alias   = "edge"
  profile = local.workspace["profile"]
}

data "aws_acm_certificate" "www" {
  provider = aws.edge
  domain   = local.workspace["domain"]
  statuses = [
    "ISSUED",
  ]
}

module "www" {
  source = "../../../github/terraform-public-static-assets"
  name   = "www-willfarrell-ca"
  aliases = [
    local.workspace["domain"],
    "willfarrell.ca",
  ]
  acm_certificate_arn    = data.aws_acm_certificate.www.arn
  lambda_origin_response = file("${path.module}/origin-response.js")
  logging_bucket         = "${local.workspace["name"]}-${terraform.workspace}-edge-logs"
  providers = {
    aws = aws.edge
  }
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
//output "bucket" {
//  value = "${module.www.bucket}"
//}
