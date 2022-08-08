locals {
  env = {
    default = {
      env     = terraform.workspace
      name    = "willfarrell"
      profile = "willfarrell"
      region  = "ca-central-1"
      domain  = "resume.willfarrell.ca"
    }
    production = {
      domain = "resume.willfarrell.ca"
    }
    staging = {
      domain = "uat-resume.willfarrell.ca"
    }
    testing = {
      domain = "qa-resume.willfarrell.ca"
    }
    development = {
      domain = "dev-resume.willfarrell.ca"
    }
  }

  workspace = merge(local.env["default"], local.env[terraform.workspace])
}

output "workspace" {
  value = terraform.workspace
}

