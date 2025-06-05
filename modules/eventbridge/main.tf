resource "aws_scheduler_schedule" "monthly_lambda_trigger" {
  name       = var.eventbridge_rule_name
  group_name = var.scheduler_group_name
  schedule_expression          = var.cron_expression  
  schedule_expression_timezone = var.schedule_expression_timezone     

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_function_arn
    role_arn = var.eventbridge_scheduler_execution_role_arn

    # Add retry policy for reliability
    retry_policy {
      maximum_retry_attempts       = var.maximum_retry_attempts
      maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
    }
  }
}
