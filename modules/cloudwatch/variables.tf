variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
  default     = 30
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

variable "kms_key_arn" {
  description = "KMS Key ARN for encrypting CloudWatch logs"
  type        = string
}

variable "eventbridge_rule_name" {
  description = "EventBridge rule name"
  type        = string
}
