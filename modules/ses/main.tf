resource "aws_ses_email_identity" "sender" {
  email = var.sender_email
}

resource "aws_ses_email_identity" "recipient" {
  count = var.verify_recipient ? length(var.recipient_email) : 0
  email = var.recipient_email[count.index]
}
