variable "lambda_role_name" {
  type        = string
  description = "Role name of the lambda in main/shared account"
}

variable "assume_role_name" {
  type        = string
  description = "Role name to assume in target accounts"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "target_account_ids" {
  type        = list(string)
  description = "List of AWS account IDs where the Lambda will assume roles"
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to be triggered by EventBridge Scheduler"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing EBS unused volumes reports"
  type        = string
  default     = "ebs-unused-reports"
}

variable "tags" {
  description = "Key-value pairs of tags to apply to all resources."
  type        = map(string)
}

variable "environment" {
    type = string
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