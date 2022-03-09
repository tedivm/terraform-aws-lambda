output "aws_iam_role" {
  value = aws_iam_role.iam_for_lambda
}

output "aws_lambda_function" {
  value = aws_lambda_function.main
}
