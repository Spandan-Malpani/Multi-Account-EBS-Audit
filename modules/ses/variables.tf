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
