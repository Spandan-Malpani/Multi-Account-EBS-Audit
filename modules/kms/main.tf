data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_key" "cw_loggroup_kms_key" {
  description              = "KMS key for encrypting CloudWatch log groups"
  enable_key_rotation      = var.enable_key_rotation
  deletion_window_in_days  = var.kms_deletion_window_in_days
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage                = "ENCRYPT_DECRYPT"

  tags = merge(var.tags, {
    Name = "cw_loggroup_kms_key"
  })
}

resource "aws_kms_key_policy" "cw_loggroup_key_policy" {
  key_id = aws_kms_key.cw_loggroup_kms_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowKeyAdminAccess",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : [
          "kms:*"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowCloudWatchLogsEncryption",
        Effect : "Allow",
        Principal : {
          Service : "logs.${data.aws_region.current.name}.amazonaws.com"
        },
        Action : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        Resource : "*",
        Condition : {
          ArnEquals : {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
          }
        }
      }
    ]
  })
}
