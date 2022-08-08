locals {
  env = {
    default = {
      env     = terraform.workspace
      name    = "willfarrell"
      profile = "willfarrell"
      region  = "ca-central-1"
      domain  = "www.willfarrell.ca"
    }
    production = {
      domain = "www.willfarrell.ca"
    }
    staging = {
      domain = "uat-www.willfarrell.ca"
    }
    testing = {
      domain = "qa-www.willfarrell.ca"
    }
    development = {
      domain = "dev-www.willfarrell.ca"
    }
  }

  workspace = merge(local.env["default"], local.env[terraform.workspace])
}

output "workspace" {
  value = terraform.workspace
}

