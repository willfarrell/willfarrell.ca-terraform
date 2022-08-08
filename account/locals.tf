locals {
  env = {
    default = {
      env     = "${terraform.workspace}"
      name    = "willfarrell"
      profile = "willfarrell"
      region  = "ca-central-1"
    }

    production = {}

    staging = {}

    testing = {}

    development = {}
  }

  workspace = "${merge(local.env["default"], local.env[terraform.workspace])}"
}
