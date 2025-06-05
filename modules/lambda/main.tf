data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = var.lambda_code_path_ebs_audit_processor
  output_path = "${path.module}/lambda_function_ebs_audit.zip"
}

# Create the Lambda function
resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  architectures = ["x86_64"]
  description   = "Lambda function to process unused ebs volumes"
  environment {
    variables = {
      ROLE_NAME          = var.assume_role_name
      SENDER_EMAIL       = var.sender_email
      RECIPIENT_EMAIL    = join(",", var.recipient_email)
      TARGET_ACCOUNT_IDS = join(",", var.target_account_ids)
      TARGET_REGIONS     = join(",", var.target_regions)
      REPORT_BUCKET_NAME = var.s3_bucket_name
    }
  }
  logging_config {
    application_log_level = "INFO"
    log_format = "JSON"
    log_group = "/aws/lambda/${var.lambda_function_name}_cw_loggroup"
    system_log_level = "INFO"
  }
  runtime          = "python3.11"
  handler          = "app.lambda_handler"
  package_type     = "Zip"
  role             = var.lambda_role_arn
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  timeout          = 900 # Increased timeout for data collection
  memory_size      = 1024
  ephemeral_storage {
    size = 512
  }

  tags = merge(var.tags, {
    Name = var.lambda_function_name
  })

  depends_on = [var.lambda_logs_arn]
}