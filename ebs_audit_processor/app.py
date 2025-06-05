import os
import json
from aws_clients import assume_role
from ebs_utils import find_unused_volumes, format_as_html_table, format_as_csv
from email_utils import send_email
from s3_utils import save_csv_report_to_s3

def lambda_handler(event, context):
    target_account_ids = os.getenv("TARGET_ACCOUNT_IDS", "").split(",")
    target_regions = os.getenv("TARGET_REGIONS", "").split(",")
    role_name = os.getenv("ROLE_NAME")
    sender_email = os.getenv("SENDER_EMAIL")
    recipient_email = os.getenv("RECIPIENT_EMAIL", "").split(",")
    report_bucket_name = os.getenv("REPORT_BUCKET_NAME")

    if not (target_account_ids and target_regions and role_name and sender_email and recipient_email and report_bucket_name):
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing required parameters"})
        }

    results = []

    for account_id in target_account_ids:
        try:
            session = assume_role(account_id, role_name)
            for region in target_regions:
                unused_volumes = find_unused_volumes(session, region)
                results.append({
                    "AccountId": account_id,
                    "Region": region,
                    "Volumes": unused_volumes
                })
        except Exception as e:
            results.append({
                "AccountId": account_id,
                "Region": "N/A",
                "Volumes": [],
                "Error": str(e)
            })

    html_body = format_as_html_table(results)
    csv_content = format_as_csv(results)

    save_csv_report_to_s3(csv_content, report_bucket_name)
    send_email(sender_email, recipient_email, html_body)

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Email sent and CSV report saved to S3"})
    }
