# Lambda

This Lambda module makes tossing up new functions easy by creating the resources they need.

## Usage

### VPC Example

This example gives the function network access.

```terraform
module "lambda" {
  source  = "tedivm/lambda/aws"
  version = "~>1.0"

  name = "MyAwesomeFunction"
  description = ""

  image_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/lambda-ecs-redeploy:latest"

  vpc_id     = var.vpc_module.aws_vpc.id
  subnet_ids = var.vpc_module.subnets.private[*].id

  tags = local.tags
}
```

### No Networking Example

In this example the function has no network access. These functions launch much faster, but can only take in requests and respond to them- they can not access the internet or any networked resources. They are ideal for things like Cloudfront Lambda@Edge.

```terraform
module "lambda" {
  source  = "tedivm/lambda/aws"
  version = "~>1.0"

  name = "MyAwesomeFunction"
  description = ""

  image_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/lambda-ecs-redeploy:latest"

  enable_networking = false

  tags = local.tags
}
```

### Inline Source

This example creates a function from code inside of Terraform.

These functions can not autoupdate outside of Terraform, since their source is inside of Terraform. They are useful for Lambdas that have to have workspace specific configurations that can't be shared using environmental variables, especially when those functions are infrastructure specific.

```terraform
module "lambda" {
  source  = "tedivm/lambda/aws"
  version = "~>1.0"

  name = "MyAwesomeFunction"
  description = ""

  enable_networking = false
  use_image         = false
  function_source   = file("${path.module}/templates/hello_world.js")
  runtime           = "nodejs14.x"

  tags = local.tags
}
```


### Lambda@Edge

Lambda@Edge functions need a special permission which can be set with the `principal_services` parameter.

These functions have to be created in `us-east-1` or they will not work. They should not be attached to a VPC unless absolutely necessary.

```terraform
module "lambda" {
  source  = "app.terraform.io/explosion/core/aws//modules/lambda"
  version = "~>1.0"

  name = "MyAwesomeFunction"
  description = ""

  principal_services = ["edgelambda.amazonaws.com"]

  enable_networking = false
  use_image         = false
  function_source   = file("${path.module}/templates/hello_world.js")
  runtime           = "nodejs14.x"

  tags = local.tags
}
```


### Outputs

* `aws_lambda_function` is the function itself
* `aws_iam_role` is the IAM Role used by the function. Attach policies to this role to grant the function more permissions.


## Resources Affected

* Cloudwatch Log Group
* IAM Resources
* Lambda Function
* Security Group (if networking is enabled)
