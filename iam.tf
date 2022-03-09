

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = concat(["lambda.amazonaws.com"], var.principal_services)
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = merge({
    name = "${var.name}-role"
  }, var.tags)
}


data "aws_iam_policy_document" "lambda_service_access" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["${aws_cloudwatch_log_group.main.arn}:log-stream:*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream"
    ]
    resources = [aws_cloudwatch_log_group.main.arn]
  }
}

resource "aws_iam_policy" "lambda_service_access" {
  name   = "${var.name}-service-access"
  policy = data.aws_iam_policy_document.lambda_service_access.json

  tags = merge({
    name = "${var.name}-service-access"
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "lambda_service_access" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_service_access.arn
}


#
# VPC Permissions
#

data "aws_iam_policy" "vpc_access" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = var.enable_networking ? 1 : 0
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.vpc_access.arn
}
