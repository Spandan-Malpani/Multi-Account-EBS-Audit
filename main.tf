module "iam" {
  source             = "./modules/iam"

  lambda_role_name   = var.lambda_role_name
  lambda_function_name = var.lambda_function_name
  assume_role_name   = var.assume_role_name
  s3_bucket_name = var.s3_bucket_name
  lambda_function_arn = module.lambda.lambda_function_arn
  target_account_ids = var.target_account_ids
  tags = var.tags
  environment = var.environment
}

module "cloudwatch" {
  source               = "./modules/cloudwatch"

  retention_in_days    = var.retention_in_days
  eventbridge_rule_name = var.eventbridge_rule_name
  kms_key_arn = module.kms.kms_key_arn
  lambda_function_name = var.lambda_function_name
  tags = var.tags
  environment = var.environment
}

module "kms" {
  source = "./modules/kms"

  enable_key_rotation = var.enable_key_rotation
  kms_deletion_window_in_days = var.kms_deletion_window_in_days
  tags = var.tags
  environment = var.environment
}


module "lambda" {
    source           = "./modules/lambda"

    lambda_code_path_ebs_audit_processor = var.lambda_code_path_ebs_audit_processor
    lambda_function_name                 = var.lambda_function_name
    lambda_role_arn                      = module.iam.lambda_role_arn
    lambda_logs_arn = module.cloudwatch.lambda_logs_arn
    target_account_ids = var.target_account_ids
    target_regions = var.target_regions
    assume_role_name                     = var.assume_role_name
    sender_email                         = var.sender_email
    recipient_email                      = var.recipient_email
    s3_bucket_name = var.s3_bucket_name
    tags = var.tags
    environment = var.environment
}

module "eventbridge" {
    source = "./modules/eventbridge"

    eventbridge_rule_name = var.eventbridge_rule_name
    eventbridge_scheduler_execution_role_arn = module.iam.eventbridge_scheduler_execution_role_arn
    cron_expression = var.cron_expression
    schedule_expression_timezone = var.schedule_expression_timezone
    maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
    maximum_retry_attempts = var.maximum_retry_attempts
    lambda_function_name = var.lambda_function_name
    lambda_function_arn = module.lambda.lambda_function_arn
}

module "ses" {
  source           = "./modules/ses"
  sender_email     = var.sender_email
  recipient_email  = var.recipient_email
  verify_recipient = true # or false, depending on the environment
}

module "s3" {
  source           = "./modules/s3"
  s3_bucket_name   = var.s3_bucket_name
  tags = var.tags
}
