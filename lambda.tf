
locals {
  use_s3   = !var.use_image && var.s3_bucket != null
  use_file = !var.use_image && var.s3_bucket == null
}

resource "aws_lambda_function" "main" {
  function_name = var.name
  description   = var.description
  memory_size   = var.memory_size
  role          = aws_iam_role.iam_for_lambda.arn
  publish       = true
  timeout       = var.timeout
  runtime       = var.use_image ? null : var.runtime
  package_type  = var.use_image ? "Image" : "Zip"

  # The default option
  image_uri = var.use_image ? var.image_uri : null

  # If images aren't used see if a file is provided
  filename         = local.use_file ? data.archive_file.lambda_archive[0].output_path : var.s3_object_version
  source_code_hash = local.use_file ? data.archive_file.lambda_archive[0].output_base64sha256 : null
  handler          = local.use_file ? "index.handler" : null

  # If images aren't used and no file is provided use S3
  s3_bucket         = local.use_s3 ? null : var.s3_bucket
  s3_key            = local.use_s3 ? null : var.s3_key
  s3_object_version = local.use_s3 ? null : var.s3_object_version

  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "vpc_config" {
    for_each = var.enable_networking ? ["dummy-value"] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = [aws_security_group.main[0].id]
    }
  }

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? ["dummy-value"] : []
    content {
      variables = var.environment_variables
    }
  }

  tags = merge({
    Name       = var.name
    AutoDeploy = var.auto_deploy ? "true" : "false"
  }, var.tags)

}
