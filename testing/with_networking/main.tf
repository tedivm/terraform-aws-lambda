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

module "meta" {
  source                 = "../../../meta"
  platform               = "Testing"
  environment            = random_string.environment.result
  base_zone              = "explosion.services"
  contains_customer_data = false
  is_dev                 = true
}

module "vpc" {
  source             = "../../../vpc"
  primary_cidr_block = "10.${random_integer.network.result}.0.0/16"
  name               = module.meta.identifier

  tags = module.meta.common_tags
}

module "lambda" {
  source = "../../"
  name   = "${module.meta.identifier}-lambda"

  vpc_id          = module.vpc.aws_vpc.id
  subnet_ids      = module.vpc.subnets.private[*].id
  function_source = file("${path.cwd}/templates/hello_world.js")
  runtime         = "nodejs14.x"
  use_image       = false
}
