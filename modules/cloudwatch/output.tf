output "lambda_logs_arn" {
  value       = aws_cloudwatch_log_group.lambda_logs.arn
  description = "ARN of the CloudWatch Log Group"
}
