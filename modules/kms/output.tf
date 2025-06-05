output "kms_key_id" {
  value = aws_kms_key.cw_loggroup_kms_key.id
}

output "kms_key_arn" {
  value = aws_kms_key.cw_loggroup_kms_key.arn
}
