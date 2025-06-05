variable "lambda_function_name" {
  description = "Name of the Lambda function to trigger"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "eventbridge_scheduler_execution_role_arn" {
  description = "ARN of the scheduler execution role"
  type        = string
}

variable "eventbridge_rule_name" {
  description = "EventBridge rule name"
  type        = string
}

variable "cron_expression" {
  description = "Cron Expression for trigger"
  type        = string
}

variable "schedule_expression_timezone" {
  description = "timezone for schedule expression"
  type        = string
  default     = "Asia/Kolkata"
}

variable "scheduler_group_name" {
  description = "group name for scheduler"
  type        = string
  default     = "default"
}

variable "maximum_retry_attempts" {
  description = "maximum retry attempts for retry queue"
  type        = number
  default     = 5
}

variable "maximum_event_age_in_seconds" {
  description = "Maximum time for which event will retry in seconds"
  type        = number
  default     = 3600 # 1 hour
}