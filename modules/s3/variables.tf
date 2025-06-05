variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing EBS unused volumes reports"
  type        = string
  default     = "ebs-unused-reports"
}

variable "tags" {
  description = "Key-value pairs of tags to apply to all resources."
  type        = map(string)
}