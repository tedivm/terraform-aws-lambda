terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 3.0"
    }
  }
}

resource "random_string" "environment" {
  length  = 7
  special = false
  upper   = false
}

resource "random_integer" "network" {
  min = 200
  max = 254

}

module "lambda" {
  source = "../../"
  name   = "${random_string.environment.result}-lambda"

  enable_networking = false
  function_source   = file("${path.cwd}/templates/hello_world.js")
  runtime           = "nodejs14.x"
  use_image         = false
}
