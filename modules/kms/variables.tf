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