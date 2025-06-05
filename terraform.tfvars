# IAM
lambda_role_name     = "lambda-ebs-audit-role"  # Name of the IAM role that will be created for the Lambda function
assume_role_name     = "CrossAccountAuditRole"  # Name of the IAM role to assume in target accounts (must be created in each target account)
target_account_ids   = ["123456789", "987654321"]         # List of AWS account IDs to scan for unused EBS volumes
target_regions       = ["us-east-1", "ap-south-1"] # AWS regions to scan within each target account

# Lambda
lambda_code_path_ebs_audit_processor = "./ebs_audit_processor"  # Path to the Lambda function code directory
lambda_function_name                 = "ebs-unused-volumes-audit"  # Name of the Lambda function to be created

# Email Configuration
sender_email     = "sender@example.com"                          # Email address that will send the audit reports (must be verified in SES)
recipient_email  = ["recipient-1@example.com", "recipient-2@example.com"]  # List of email addresses to receive the audit reports

# SES
verify_recipient = true  # Whether to verify recipient emails in SES (set true for sandbox mode, false for production)

# CloudWatch
retention_in_days = 30  # Number of days to retain Lambda function logs in CloudWatch

# KMS
enable_key_rotation         = true  # Whether to enable automatic rotation of the KMS key
kms_deletion_window_in_days = 7     # Waiting period before KMS key is deleted (between 7-30 days)

# Region
aws_region = "ap-south-1"  # AWS region where the resources will be deployed

# EventBridge
eventbridge_rule_name = "monthly-ebs-audit-trigger"  # Name of the EventBridge scheduler rule
cron_expression       = "cron(0 0 1 * ? *)"         # Schedule expression (this example: midnight on 1st day of each month)
schedule_expression_timezone = "Asia/Kolkata"       # Timezone for the cron expression
scheduler_group_name = "default"                    # EventBridge scheduler group name
maximum_retry_attempts = 5                          # Maximum number of retry attempts if Lambda invocation fails
maximum_event_age_in_seconds = 3600                 # How long an event remains valid for processing (1 hour)

# S3
s3_bucket_name = "ebs-unused-reports"   # Name of the S3 Bucket to store reports

# Tags
tags = {
  environment = "test"       # Environment tag for all resources
  owner       = "YourName"   # Owner tag for all resources
  vendor      = "YourCompany" # Vendor tag for all resources
  cost_center = "YourDept"   # Cost center tag for all resources
}
