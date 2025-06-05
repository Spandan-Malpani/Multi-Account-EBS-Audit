# IAM

variable "lambda_role_name" {
  type        = string
  description = "Role name of the lambda in main/shared account"
}

# Lambda

variable "lambda_code_path_ebs_audit_processor" {
  description = "Path to Lambda source code folder"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "target_account_ids" {
  type        = list(string)
  description = "List of AWS account IDs where the Lambda will assume roles"
}

variable "target_regions" {
  type        = list(string)
  description = "List of AWS regions to scan for EBS volumes"
}

variable "assume_role_name" {
  description = "Role name to assume in target accounts"
  type        = string
}

# SES

variable "sender_email" {
  description = "Email address to verify as the sender"
  type        = string
}

variable "recipient_email" {
  description = "Email address to verify as the recipient"
  type        = list(string)
}

variable "verify_recipient" {
  description = "Enable recipient verification (set to false for production SES)"
  type        = bool
  default     = true
}

# Cloudwatch

variable "retention_in_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
  default     = 30
}

# KMS

variable "enable_key_rotation" {
  description = "Enable key rotation true/false"
  type = bool
  default = true
}

variable "kms_deletion_window_in_days" {
  description = "KMS Deletion Window in Days"
  type = number
  default = 7
}

# Region

variable "aws_region" {
    description = "Region for creation of resources"
    type = string  
}

# EventBridge

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

# S3

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing EBS unused volumes reports"
  type        = string
  default     = "ebs-unused-reports"
}

# Tags

variable "tags" {
  description = "Key-value pairs of tags to apply to all resources."
  type        = map(string)
}

variable "environment" {
    type = string
    default = "test"
}

variable "owner" {
  type        = string
  default     = ""
  description = "Owner"
}

variable "cost_center" {
  type = string
  default = ""
  description = "Cost center tag value"
}

variable "vendor" {
  type        = string
  default     = "ACC"
  description = "Vendor"
}

