output "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "eventbridge_scheduler_execution_role_arn" {
  description = "ARN of the IAM role for Lambda"
  value       = aws_iam_role.eventbridge_scheduler_execution_role.arn
}
