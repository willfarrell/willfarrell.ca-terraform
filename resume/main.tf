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

provider "aws" {
  region  = local.workspace["region"]
  profile = local.workspace["profile"]
}

provider "aws" {
  region  = "us-east-1"
  alias   = "edge"
  profile = local.workspace["profile"]
}

data "aws_acm_certificate" "resume" {
  provider = aws.edge
  domain   = local.workspace["domain"]FYI Mandy had her baby today Having a
  statuses = [
    "ISSUED",
  ]
}

module "resume" {
  source = "git@github.com:willfarrell/terraform-public-static-assets?ref=v0.2.1"
  name   = "resume-willfarrell-ca"
  aliases = [
    local.workspace["domain"],
  ]
  acm_certificate_arn    = data.aws_acm_certificate.resume.arn
  lambda_origin_response = file("${path.module}/origin-response.js")
  logging_bucket         = "${local.workspace["name"]}-${terraform.workspace}-edge-logs"
  providers = {
    aws = aws.edge
  }
}
