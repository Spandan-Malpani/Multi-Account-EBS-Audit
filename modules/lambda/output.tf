output "lambda_function_arn" {
    description = "Lambda Function ARN"
    value = aws_lambda_function.lambda_function.arn
}