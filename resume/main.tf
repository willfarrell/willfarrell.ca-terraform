# https://github.com/hashicorp/terraform/issues/16611
terraform {
  backend "s3" {
    bucket         = "willfarrell.ca-terraform-state"
    key            = "app/resume/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    profile        = "willfarrell"
    dynamodb_table = "willfarrell.ca-terraform-state"
  }
}

variable "aws_account_id" {}
variable "aws_region" {}
variable "aws_profile" {}
variable "domain_name" {}

provider "aws" {
  region = "${var.aws_region}"
  profile = "willfarrell"
}

//module "s3_resume_website" {
//  source = "../modules/s3-simple-website"
//  aws_account_id = "${var.aws_account_id}"
//  aws_region = "${var.aws_region}"
//  bucket = "resume.${var.domain_name}"
//}
