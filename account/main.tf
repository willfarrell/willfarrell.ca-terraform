terraform {
  backend "s3" {
    bucket         = "willfarrell.ca-terraform-state"
    key            = "willfarrell/account/terraform.tfstate"
    region         = "ca-central-1"
    profile        = "willfarrell"
    dynamodb_table = "willfarrell.ca-terraform-state"
    encrypt        = true
  }
}

# Edge

provider "aws" {
  profile = "${local.workspace["profile"]}"
  region  = "us-east-1"
  alias   = "edge"
}

//module "apig-cloudwatch" {
//  source = "git@github.com:tesera/terraform-modules//account/api-gateway?ref=v0.4.6"
//  providers = {
//    aws = "aws.edge"
//  }
//}
//
//module "cloudtrail" {
//  source         = "git@github.com:tesera/terraform-modules//account/cloudtrail?ref=v0.4.8"
//  name           = "${local.workspace["name"]}"
//  logging_bucket = "${module.edge-logs.id}"
//  providers = {
//    aws = "aws.edge"
//  }
//}

module "edge-logs" {
  source = "git@github.com:willfarrell/terraform-s3-logs-module?ref=v0.4.7"
  name   = "${local.workspace["name"]}-${terraform.workspace}-edge"
  providers = {
    aws = "aws.edge"
  }
  tags = {
    Name = "Edge Logs"
  }
}

# Primary Region
provider "aws" {
  profile = "${local.workspace["profile"]}"
  region  = "${local.workspace["region"]}"
}

//module "region-logs" {
//  source = "git@github.com:willfarrell/terraform-s3-logs-module?ref=v0.4.7"
//  name   = "${local.workspace["name"]}-${terraform.workspace}-${local.workspace["region"]}"
//  tags   = {
//    Name = "${local.workspace["region"]} Logs"
//  }
//}
