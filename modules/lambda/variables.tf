variable "lambda_code_path_ebs_audit_processor" {
  description = "Path to Lambda source code folder"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for the Lambda function"
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

variable "sender_email" {
  description = "SES verified sender email"
  type        = string
}

variable "recipient_email" {
  description = "SES verified recipient email"
  type        = list(string)
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

variable "lambda_logs_arn" {
  description = "ARN for CloudWatch logs"
  type        = string
}